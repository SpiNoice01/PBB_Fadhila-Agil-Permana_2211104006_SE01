import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> mangaList = [];
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
      // ignore: avoid_print
      print(e); // Print error for debugging
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

                // Extract manga details safely
                final title =
                    manga['attributes']['title']?['en'] ?? "Unknown Title";
                final desc = manga['attributes']['description']?['en'] ??
                    "No Description";
                final coverArt = manga['relationships']?.firstWhere(
                    (rel) => rel['type'] == 'cover_art',
                    orElse: () => null)?['attributes']?['fileName'];
                final imageUrl = coverArt != null
                    ? "https://api.mangadex.org/cover/${['id']}"
                    : "https://via.placeholder.com/150";

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                    title: Text(title),
                    subtitle: Text(desc),
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
