import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/read_manga.dart'; // Import the new read manga screen

class DetailScreen extends StatefulWidget {
  final String mangaId;

  const DetailScreen({super.key, required this.mangaId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
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
      final manga = await MangaDexService.getMangaDetails(widget.mangaId);
      setState(() {
        mangaDetails = manga;
        isLoading = false;
      });
      print("Manga details fetched: $mangaDetails");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching manga details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : mangaDetails == null
              ? const Center(child: Text('Error loading manga details'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                ),
    );
  }
}
