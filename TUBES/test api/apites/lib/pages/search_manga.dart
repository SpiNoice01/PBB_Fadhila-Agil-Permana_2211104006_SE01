import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';

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
        title: const Text('Search Manga'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchManga(_searchController.text);
                  },
                ),
              ),
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
                ),
        ],
      ),
    );
  }
}
