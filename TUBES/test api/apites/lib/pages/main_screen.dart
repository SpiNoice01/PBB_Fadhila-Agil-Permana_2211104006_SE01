// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> mangaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchManga();
  }

  Future<void> fetchManga() async {
    try {
      final mangas = await MangaDexService.getMangaList(title: "");
      setState(() {
        mangaList = mangas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching manga list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                final manga = mangaList[index];

                // Extract manga details
                final title =
                    manga['attributes']['title']?['en'] ?? "Unknown Title";
                final desc = manga['attributes']['description']?['en'] ??
                    "No Description";
                final imageUrl =
                    manga['coverUrl'] ?? "https://via.placeholder.com/150";

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                    title: Text(title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(desc,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(mangaId: manga['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
