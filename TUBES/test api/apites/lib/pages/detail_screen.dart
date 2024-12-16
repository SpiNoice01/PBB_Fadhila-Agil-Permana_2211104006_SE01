import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/read_manga.dart';

class DetailScreen extends StatefulWidget {
  final String mangaId;

  const DetailScreen({super.key, required this.mangaId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? mangaDetails;
  List<Map<String, dynamic>> chapters = [];
  bool isLoadingMore = false;
  bool isError = false;
  int currentPage = 0;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();

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
      fetchChapters();
    } catch (e) {
      setState(() {
        isError = true;
      });
      print("Error fetching manga details: $e");
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
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
        isError = true;
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
        title: const Text('Manga Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: isError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading manga details'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (mangaDetails == null)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        if (mangaDetails!['coverUrl'] != null)
                          Image.network(
                            mangaDetails!['coverUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                        const SizedBox(height: 16),
                        Text(
                          mangaDetails!['attributes']['title']?['en'] ??
                              "Unknown Title",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mangaDetails!['attributes']['description']?['en'] ??
                              "No Description",
                          style: Theme.of(context).textTheme.bodyMedium,
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
                          child: const Text('Read Manga'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chapters',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        ...chapters.map((chapter) {
                          final chapterTitle = chapter['attributes']['title'] ??
                              'Chapter ${chapter['attributes']['chapter']}';
                          final pageCount = chapter['pageCount'];
                          return Card(
                            child: ListTile(
                              title: Text(chapterTitle),
                              subtitle: Text('Pages: $pageCount'),
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
                        }).toList(),
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
