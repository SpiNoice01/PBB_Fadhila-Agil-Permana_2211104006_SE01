import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apites/pages/detail_screen.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteMangaIds = [];
  List<Map<String, dynamic>> favoriteMangaDetails = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('likedManga') ?? [];
    setState(() {
      favoriteMangaIds = ids;
    });
    await fetchFavoriteMangaDetails(ids);
  }

  Future<void> fetchFavoriteMangaDetails(List<String> ids) async {
    List<Map<String, dynamic>> mangaDetails = [];
    for (String id in ids) {
      final manga = await MangaDexService.getMangaDetails(id);
      mangaDetails.add(manga);
    }
    setState(() {
      favoriteMangaDetails = mangaDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color:
                Color.fromARGB(255, 237, 237, 237), // Warna putih keabu-abuan
          ),
        ),
        backgroundColor: const Color(0xFF2C2F33), // Discord dark theme color
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 237, 237, 237), // Warna putih keabu-abuan
        ),
      ),
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
      body: favoriteMangaDetails.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMangaDetails.length,
              itemBuilder: (context, index) {
                final manga = favoriteMangaDetails[index];
                final title =
                    manga['attributes']['title']?['en'] ?? "Unknown Title";
                final desc = manga['attributes']['description']?['en'] ??
                    "No Description";
                final imageUrl =
                    manga['coverUrl'] ?? "https://via.placeholder.com/150";
                final genres = (manga['attributes']['tags'] as List<dynamic>)
                    .map((tag) => tag['attributes']['name']['en'] as String)
                    .take(4)
                    .toList();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(mangaId: manga['id']),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xFF2C2F33),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  desc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 3.0,
                                  runSpacing: -10.0,
                                  children: genres
                                      .map((genre) => Chip(
                                            label: Text(genre),
                                            backgroundColor:
                                                Colors.black.withOpacity(0.5),
                                            labelStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
