import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Import the colors.dart file

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchManga(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final results = await MangaDexService.getMangaList(title: query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error searching manga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Manga',
          style: TextStyle(color: Color.fromARGB(255, 237, 237, 237)),
        ),
        backgroundColor: const Color(0xFF2C2F33), // Discord dark theme color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    searchManga(_searchController.text);
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (query) {
                searchManga(query);
              },
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final manga = searchResults[index];

                      // Extract manga details
                      final title = manga['attributes']['title']?['en'] ??
                          "Unknown Title";
                      final desc = manga['attributes']['description']?['en'] ??
                          "No Description";
                      final imageUrl = manga['coverUrl'] ??
                          "https://via.placeholder.com/150";

                      return Card(
                        color:
                            const Color(0xFF2C2F33), // Discord dark theme color
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_not_supported),
                          ),
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
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
                ),
        ],
      ),
    );
  }
}
