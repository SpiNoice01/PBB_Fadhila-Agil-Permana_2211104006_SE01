import 'package:apites/collection/colors.dart';
import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/read/read_manga.dart';
import 'package:apites/pages/detail/manga_details_header.dart';
import 'package:apites/pages/detail/manga_chapters_list.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String mangaId;

  const DetailScreen({super.key, required this.mangaId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? mangaDetails;
  Map<String, dynamic>? authorDetails;
  List<Map<String, dynamic>> chapters = [];
  bool isLoadingMore = false;
  bool isError = false;
  bool isChapterError = false;
  int currentPage = 0;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    fetchMangaDetails();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchMangaDetails() async {
    try {
      final manga = await MangaDexService.getMangaDetails(widget.mangaId);
      setState(() {
        mangaDetails = manga;
        isError = false;
      });
      fetchAuthorDetails(manga['relationships']);
      fetchChapters(0);
    } catch (e) {
      setState(() {
        isError = true;
      });
      print("Error fetching manga details: $e");
    }
  }

  Future<void> fetchAuthorDetails(List<dynamic> relationships) async {
    try {
      final authorRelationship = relationships
          .firstWhere((rel) => rel['type'] == 'author', orElse: () => null);
      if (authorRelationship != null) {
        final authorId = authorRelationship['id'];
        final author = await MangaDexService.getAuthorDetails(authorId);
        setState(() {
          authorDetails = author;
        });
      }
    } catch (e) {
      print("Error fetching author details: $e");
    }
  }

  Future<void> fetchChapters(int page) async {
    try {
      if (page == 0) {
        setState(() {
          chapters = [];
        });
      } else {
        setState(() {
          isLoadingMore = true;
        });
      }

      final newChapters = await MangaDexService.getMangaChapters(
        widget.mangaId,
        limit: limit,
        offset: page * limit,
      );
      final chaptersWithDetails =
          await Future.wait(newChapters.map((chapter) async {
        final chapterDetails =
            await MangaDexService.getChapterDetails(chapter['id']);
        return {
          ...chapter,
          'pageCount': chapterDetails['attributes']['pages'] ?? 'Unknown',
        };
      }));

      setState(() {
        if (page == 0) {
          chapters = chaptersWithDetails;
        } else {
          chapters.addAll(chaptersWithDetails);
        }
        isLoadingMore = false;
        isChapterError = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
        isChapterError = true;
      });
      print("Error fetching chapters: $e");
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        currentPage++;
      });
      fetchChapters(currentPage);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      currentPage = 0;
      isError = false;
      isChapterError = false;
    });
    await fetchMangaDetails();
    _scrollController.jumpTo(_scrollPosition);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> checkIfLiked() async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    return likedManga.contains(widget.mangaId);
  }

  Future<void> toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    bool isFavorite;
    if (await checkIfLiked()) {
      likedManga.remove(widget.mangaId);
      isFavorite = false;
    } else {
      likedManga.add(widget.mangaId);
      isFavorite = true;
    }
    await prefs.setStringList('likedManga', likedManga);

    // Show GetX Snackbar at the top
    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite
          ? 'Manga has been added to your favorites.'
          : 'Manga has been removed from your favorites.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  Future<Map<String, dynamic>?> getBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final chapterId = prefs.getString('bookmark_${widget.mangaId}');
    if (chapterId != null) {
      final chapterDetails = await MangaDexService.getChapterDetails(chapterId);
      return {
        'chapterId': chapterId,
        'chapterTitle': chapterDetails['attributes']['title'] ??
            'Chapter ${chapterDetails['attributes']['chapter']}',
        'chapterNumber': chapterDetails['attributes']['chapter'] ?? 'Unknown',
      };
    }
    return null;
  }

  String truncateTitle(String title, int wordLimit) {
    final words = title.split(' ');
    if (words.length <= wordLimit) {
      return title;
    } else {
      return '${words.take(wordLimit).join(' ')}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manga Details',
            style: TextStyle(color: Color.fromARGB(255, 237, 237, 237)),
          ),
          backgroundColor: const Color(0xFF2C2F33),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh,
                  color: Color.fromARGB(255, 237, 237, 237)),
              onPressed: _refresh,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF23272A),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Error loading manga details',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else if (mangaDetails == null)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    MangaDetailsHeader(
                      mangaDetails: mangaDetails!,
                      authorDetails: authorDetails,
                      isLiked:
                          false, // Placeholder, will be updated by FutureBuilder
                      toggleLike: toggleLike,
                    ),
                    FutureBuilder<Map<String, dynamic>?>(
                      future: getBookmark(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading bookmark'));
                        } else {
                          final bookmark = snapshot.data;
                          return ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadMangaScreen(
                                    mangaId: widget.mangaId,
                                    chapterId: bookmark?['chapterId'],
                                  ),
                                ),
                              );
                              _refresh();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mangaDex,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(bookmark != null
                                ? 'Continue Reading, \nChapter ${bookmark['chapterNumber']}: ${truncateTitle(bookmark['chapterTitle'], 3)}'
                                : 'Start Reading'),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    MangaChaptersList(
                      chapters: chapters,
                      isLoadingMore: isLoadingMore,
                      isChapterError: isChapterError,
                      currentPage: currentPage,
                      fetchChapters: fetchChapters,
                      mangaId: widget.mangaId,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
