import 'package:apites/pages/read_manga.dart';
import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';

class DetailScreen extends StatefulWidget {
  final String mangaId;

  const DetailScreen({super.key, required this.mangaId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? mangaDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMangaDetails();
  }

  Future<void> fetchMangaDetails() async {
    try {
      final details = await MangaDexService.getMangaDetails(widget.mangaId);
      setState(() {
        mangaDetails = details;
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
        title: Text(mangaDetails?['attributes']['title']?['en'] ?? 'Detail'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : mangaDetails == null
              ? const Center(
                  child:
                      Text('Failed to load details. Please try again later.'),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            mangaDetails?['relationships']?.firstWhere(
                                      (rel) => rel['type'] == 'cover_art',
                                      orElse: () => null,
                                    )?['attributes']?['fileName'] !=
                                    null
                                ? "https://uploads.mangadex.org/covers/${mangaDetails?['id']}/${mangaDetails?['relationships']?.firstWhere(
                                    (rel) => rel['type'] == 'cover_art',
                                    orElse: () => null,
                                  )?['attributes']?['fileName']}"
                                : "https://via.placeholder.com/300",
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mangaDetails?['attributes']['title']?['en'] ??
                              "Unknown Title",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mangaDetails?['attributes']['description']?['en'] ??
                              "No Description Available",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the ReadMangaScreen with a sample chapterId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReadMangaScreen(
                                  chapterId:
                                      'sample-chapter-id', // Replace with actual chapter ID
                                ),
                              ),
                            );
                          },
                          child: const Text('Read Manga'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
