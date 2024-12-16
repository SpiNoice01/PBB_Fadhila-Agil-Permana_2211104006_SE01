import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';

class ReadMangaScreen extends StatefulWidget {
  final String mangaId;

  const ReadMangaScreen({super.key, required this.mangaId});

  @override
  _ReadMangaScreenState createState() => _ReadMangaScreenState();
}

class _ReadMangaScreenState extends State<ReadMangaScreen> {
  List<String> pages = [];
  bool isLoading = true;
  int currentPage = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchMangaPages();
  }

  Future<void> fetchMangaPages() async {
    try {
      // Fetch the first chapter's pages for simplicity
      final chapters = await MangaDexService.getMangaChapters(widget.mangaId);
      if (chapters.isNotEmpty) {
        final chapterId = chapters.first['id'];
        final pages = await MangaDexService.getChapterPages(chapterId);
        setState(() {
          this.pages = pages;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching manga pages: $e");
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Manga'),
        actions: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages.isEmpty
              ? const Center(child: Text('No pages available'))
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: PageController(initialPage: currentPage),
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
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
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _previousPage,
                          ),
                          Text('Page ${currentPage + 1} of ${pages.length}'),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: _nextPage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
