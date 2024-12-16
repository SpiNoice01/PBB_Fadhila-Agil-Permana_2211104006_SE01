import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';

class ReadMangaScreen extends StatefulWidget {
  final String chapterId;

  const ReadMangaScreen({super.key, required this.chapterId});

  @override
  State<ReadMangaScreen> createState() => _ReadMangaScreenState();
}

class _ReadMangaScreenState extends State<ReadMangaScreen> {
  List<String>? pages;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChapterPages();
  }

  Future<void> fetchChapterPages() async {
    try {
      final pages = await MangaDexService.getChapterPages(widget.chapterId);
      setState(() {
        this.pages = pages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Manga'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages == null
              ? const Center(
                  child: Text('Failed to load pages. Please try again later.'),
                )
              : ListView.builder(
                  itemCount: pages!.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      pages![index],
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    );
                  },
                ),
    );
  }
}