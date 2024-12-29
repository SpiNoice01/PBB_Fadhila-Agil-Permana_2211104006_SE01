import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/collection/colors.dart'; // Import the colors.dart file
import 'package:shared_preferences/shared_preferences.dart';

class ReadMangaScreen extends StatefulWidget {
  final String mangaId;
  final String? chapterId;

  const ReadMangaScreen({super.key, required this.mangaId, this.chapterId});

  @override
  _ReadMangaScreenState createState() => _ReadMangaScreenState();
}

class _ReadMangaScreenState extends State<ReadMangaScreen> {
  List<String> pages = [];
  bool isLoading = true;
  int currentPage = 0;
  bool isLiked = false;
  String chapterTitle = '';
  String chapterNumber = '';
  Color backgroundColor = Colors.white;
  Color appBarColor = Colors.white;
  Color textColor = Colors.black;
  Color iconColor = Colors.black;
  String? nextChapterId;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    fetchMangaPages();
    checkIfLiked(); // Tambahkan ini
  }

  Future<void> checkIfLiked() async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    setState(() {
      isLiked = likedManga.contains(widget.mangaId);
    });
  }

  Future<void> toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    if (isLiked) {
      likedManga.remove(widget.mangaId);
    } else {
      likedManga.add(widget.mangaId);
    }
    await prefs.setStringList('likedManga', likedManga);
    setState(() {
      isLiked = !isLiked;
    });
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
      appBarColor =
          color.withOpacity(0.8); // Make the app bar color slightly brighter
      if (color == const Color(0xFF23272A)) {
        // Dark theme
        textColor = Colors.white;
        iconColor = Colors.white;
      } else {
        textColor = Colors.black;
        iconColor = Colors.black;
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
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                color: iconColor),
            onPressed: toggleLike,
          ),
          PopupMenuButton<Color>(
            onSelected: _changeBackgroundColor,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Colors.white,
                child: Text('White'),
              ),
              const PopupMenuItem(
                value: Color(0xFF23272A), // Discord dark theme color
                child: Text('Dark'),
              ),
              const PopupMenuItem(
                value: Color(0xFFFFF3E0), // Warm color
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
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemCount: pages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == pages.length) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'End of Chapter',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mangaDex,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (nextChapterId != null)
                                      ElevatedButton(
                                        onPressed: _readNextChapter,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.mangaDex,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // Less rounded corners
                                          ),
                                        ),
                                        child: const Text('Read Next Chapter'),
                                      ),
                                  ],
                                ),
                              );
                            }
                            return Image.network(
                              pages[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: iconColor),
                              onPressed: _previousPage,
                            ),
                            Text(
                              'Page ${currentPage + 1} of ${pages.length}',
                              style: TextStyle(color: textColor),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward, color: iconColor),
                              onPressed: _nextPage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
