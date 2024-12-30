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
  bool isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  String selectedGenre = 'All';
  String selectedSort = 'Relevance';
  final List<String> genres = [
    'All',
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi'
  ];
  final List<String> sortOptions = ['Relevance', 'Rating', 'Newest'];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  final int pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreManga();
    }
  }

  Future<void> searchManga(String query, String genre, String sort) async {
    setState(() {
      isLoading = true;
      currentPage = 0;
      searchResults.clear();
    });
    try {
      List<Map<String, dynamic>> results;
      if (sort == 'Rating') {
        results = await MangaDexService.getMangaListSortedByRating(
            title: query, limit: pageSize, offset: currentPage * pageSize);
      } else {
        results = await MangaDexService.getMangaList(
            title: query, limit: pageSize, offset: currentPage * pageSize);
      }

      setState(() {
        List<Map<String, dynamic>> filteredResults = results;
        if (genre != 'All') {
          filteredResults = results.where((manga) {
            final mangaGenres = (manga['attributes']['tags'] as List<dynamic>)
                .map((tag) => tag['attributes']['name']['en'] as String)
                .toList();
            return mangaGenres.contains(genre);
          }).toList();
        }

        if (sort == 'Newest') {
          filteredResults.sort((a, b) {
            final dateA = DateTime.tryParse(a['attributes']['createdAt']) ??
                DateTime(1970);
            final dateB = DateTime.tryParse(b['attributes']['createdAt']) ??
                DateTime(1970);
            return dateB.compareTo(dateA);
          });
        }

        searchResults = filteredResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error searching manga: $e");
    }
  }

  Future<void> loadMoreManga() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });
    try {
      List<Map<String, dynamic>> results;
      if (selectedSort == 'Rating') {
        results = await MangaDexService.getMangaListSortedByRating(
            title: _searchController.text,
            limit: pageSize,
            offset: (currentPage + 1) * pageSize);
      } else {
        results = await MangaDexService.getMangaList(
            title: _searchController.text,
            limit: pageSize,
            offset: (currentPage + 1) * pageSize);
      }

      setState(() {
        List<Map<String, dynamic>> filteredResults = results;
        if (selectedGenre != 'All') {
          filteredResults = results.where((manga) {
            final mangaGenres = (manga['attributes']['tags'] as List<dynamic>)
                .map((tag) => tag['attributes']['name']['en'] as String)
                .toList();
            return mangaGenres.contains(selectedGenre);
          }).toList();
        }

        if (selectedSort == 'Newest') {
          filteredResults.sort((a, b) {
            final dateA = DateTime.tryParse(a['attributes']['createdAt']) ??
                DateTime(1970);
            final dateB = DateTime.tryParse(b['attributes']['createdAt']) ??
                DateTime(1970);
            return dateB.compareTo(dateA);
          });
        }

        searchResults.addAll(filteredResults);
        currentPage++;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
      print("Error loading more manga: $e");
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
                    searchManga(
                        _searchController.text, selectedGenre, selectedSort);
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
                searchManga(query, selectedGenre, selectedSort);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedGenre,
                    dropdownColor: const Color(0xFF2C2F33),
                    style: const TextStyle(color: Colors.white),
                    items: genres.map((String genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedGenre = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedSort,
                    dropdownColor: const Color(0xFF2C2F33),
                    style: const TextStyle(color: Colors.white),
                    items: sortOptions.map((String sortOption) {
                      return DropdownMenuItem<String>(
                        value: sortOption,
                        child: Text(sortOption),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSort = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: searchResults.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == searchResults.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
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
