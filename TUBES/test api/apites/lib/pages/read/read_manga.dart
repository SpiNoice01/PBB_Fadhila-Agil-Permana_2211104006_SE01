import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apites/pages/read/manga_page_viewer.dart';
import 'package:apites/pages/read/manga_navigation_bar.dart';
import 'package:get/get.dart';

class ReadMangaScreen extends StatefulWidget {
  final String mangaId;
  final String? chapterId;

  const ReadMangaScreen({super.key, required this.mangaId, this.chapterId});

  @override
  _ReadMangaScreenState createState() => _ReadMangaScreenState();
}

class _ReadMangaScreenState extends State<ReadMangaScreen> {
  final BookmarkController bookmarkController = Get.put(BookmarkController());

  List<String> pages = [];
  bool isLoading = true;
  int currentPage = 0;
  String chapterTitle = '';
  String chapterNumber = '';
  Color backgroundColor = const Color(0xFF2C2F33); // Discord black background
  Color appBarColor = const Color(0xFF2C2F33); // Default to white background
  Color textColor =
      const Color.fromARGB(255, 203, 203, 203); // Default to white text
  Color iconColor =
      const Color.fromARGB(255, 185, 184, 184); // Default to white icons
  String? nextChapterId;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    fetchMangaPages();
    bookmarkController.checkIfLiked(widget.mangaId);
  }

  Future<void> fetchMangaPages() async {
    try {
      final chapterId = widget.chapterId ??
          (await MangaDexService.getMangaChapters(widget.mangaId,
                  limit: 1, offset: 0))
              .first['id'];
      final chapterDetails = await MangaDexService.getChapterDetails(chapterId);
      final pages = await MangaDexService.getChapterPages(chapterId);
      final nextChapter =
          await MangaDexService.getNextChapter(widget.mangaId, chapterId);
      setState(() {
        this.pages = pages;
        chapterTitle = chapterDetails['attributes']['title'] ??
            'Chapter ${chapterDetails['attributes']['chapter']}';
        chapterNumber = chapterDetails['attributes']['chapter'] ?? '';
        nextChapterId = nextChapter?['id'];
        isLoading = false;
      });
      bookmarkController.saveBookmark(widget.mangaId, chapterId);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching manga pages: $e");
    }
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _changeBackgroundColor(Color color) {
    setState(() {
      backgroundColor = color;
      appBarColor = color.withOpacity(0.8);
      if (color == const Color.fromARGB(255, 217, 217, 217) ||
          color == const Color.fromARGB(255, 195, 169, 128)) {
        textColor = const Color.fromARGB(255, 36, 36, 36);
        iconColor = const Color.fromARGB(255, 36, 36, 36);
      } else {
        textColor = const Color.fromARGB(255, 124, 124, 124);
        iconColor = const Color.fromARGB(255, 124, 124, 124);
      }
    });
  }

  void _readNextChapter() {
    if (nextChapterId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReadMangaScreen(
            mangaId: widget.mangaId,
            chapterId: nextChapterId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$chapterTitle (Chapter $chapterNumber)',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                    bookmarkController.isLiked.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: iconColor),
                onPressed: () => bookmarkController.toggleLike(widget.mangaId),
              )),
          PopupMenuButton<Color>(
            onSelected: _changeBackgroundColor,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Color.fromARGB(255, 217, 217, 217),
                child: Text('White'),
              ),
              const PopupMenuItem(
                value: Colors.black,
                child: Text('Dark'),
              ),
              const PopupMenuItem(
                value: Color.fromARGB(255, 195, 169, 128),
                child: Text('Warm'),
              ),
            ],
            icon: Icon(Icons.color_lens, color: iconColor),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages.isEmpty
              ? const Center(child: Text('No pages available'))
              : Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                        child: MangaPageViewer(
                          pages: pages,
                          currentPage: currentPage,
                          pageController: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          nextChapterId: nextChapterId,
                          readNextChapter: _readNextChapter,
                        ),
                      ),
                      MangaNavigationBar(
                        currentPage: currentPage,
                        totalPages: pages.length,
                        previousPage: _previousPage,
                        nextPage: _nextPage,
                        iconColor: iconColor,
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
    );
  }
}

class BookmarkController extends GetxController {
  var isLiked = false.obs;
  var bookmarkedChapterId = ''.obs;
  var bookmarkedChapterTitle = ''.obs;

  Future<void> checkIfLiked(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    isLiked.value = likedManga.contains(mangaId);
  }

  Future<void> toggleLike(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    if (isLiked.value) {
      likedManga.remove(mangaId);
    } else {
      likedManga.add(mangaId);
    }
    await prefs.setStringList('likedManga', likedManga);
    isLiked.value = !isLiked.value;
  }

  Future<void> getBookmark(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final chapterId = prefs.getString('bookmark_$mangaId');
    if (chapterId != null) {
      bookmarkedChapterId.value = chapterId;
      // Fetch chapter details to get the title
      // Assuming MangaDexService.getChapterDetails is available
      final chapterDetails = await MangaDexService.getChapterDetails(chapterId);
      bookmarkedChapterTitle.value = chapterDetails['attributes']['title'] ??
          'Chapter ${chapterDetails['attributes']['chapter']}';
    }
  }

  Future<void> saveBookmark(String mangaId, String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookmark_$mangaId', chapterId);
    getBookmark(mangaId);
  }
}
