import 'package:apites/collection/colors.dart';
import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/read_manga.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchMangaDetails();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> saveMangaDetailsToCache(
      Map<String, dynamic> mangaDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'mangaDetails_${widget.mangaId}', jsonEncode(mangaDetails));
  }

  Future<Map<String, dynamic>?> getMangaDetailsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final mangaDetailsString =
        prefs.getString('mangaDetails_${widget.mangaId}');
    if (mangaDetailsString != null) {
      return jsonDecode(mangaDetailsString);
    }
    return null;
  }

  Future<void> fetchMangaDetails() async {
    try {
      final cachedMangaDetails = await getMangaDetailsFromCache();
      if (cachedMangaDetails != null) {
        setState(() {
          mangaDetails = cachedMangaDetails;
        });
      }

      final manga = await MangaDexService.getMangaDetails(widget.mangaId);
      setState(() {
        mangaDetails = manga;
        isError = false;
      });
      await saveMangaDetailsToCache(manga);
      fetchAuthorDetails(manga['relationships']);
      fetchChapters();
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

  Future<void> fetchChapters({int page = 0}) async {
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
      fetchChapters(page: currentPage);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      currentPage = 0;
      isError = false;
      isChapterError = false;
    });
    await fetchMangaDetails();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manga Details',
          style: TextStyle(color: Color.fromARGB(255, 237, 237, 237)),
        ),
        backgroundColor: const Color(0xFF2C2F33), // Discord dark theme color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
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
                  if (mangaDetails!['coverUrl'] != null)
                    CachedNetworkImage(
                      imageUrl: mangaDetails!['coverUrl'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    mangaDetails!['attributes']['title']?['en'] ??
                        "Unknown Title",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mangaDetails!['attributes']['description']?['en'] ??
                        "No Description",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: (mangaDetails!['attributes']['tags']
                            as List<dynamic>)
                        .map((tag) => Chip(
                              label: Text(tag['attributes']['name']['en']),
                              backgroundColor: const Color(0xFF2C2F33),
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  if (authorDetails != null)
                    Text(
                      'Author: ${authorDetails!['attributes']['name'] ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${mangaDetails!['attributes']['status'] ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created At: ${mangaDetails!['attributes']['createdAt'] ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color.fromARGB(
                        65, 255, 255, 255), // Warna garis pembatas
                    thickness: 1, // Ketebalan garis pembatas
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadMangaScreen(
                            mangaId: widget.mangaId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mangaDex,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Less rounded corners
                      ),
                    ),
                    child: const Text('Read Manga'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chapters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isChapterError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Error loading chapters',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => fetchChapters(page: currentPage),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = chapters[index];
                        final chapterTitle = chapter['attributes']['title'] ??
                            'Chapter ${chapter['attributes']['chapter']}';
                        final pageCount = chapter['pageCount'];
                        return Card(
                          color: const Color(
                              0xFF2C2F33), // Discord dark theme color
                          child: ListTile(
                            title: Text(
                              'Chapter ${index + 1}: $chapterTitle',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Pages: $pageCount',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadMangaScreen(
                                    mangaId: widget.mangaId,
                                    chapterId: chapter['id'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  if (isLoadingMore)
                    const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
