import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';
import 'package:apites/pages/search_manga.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _pageSize = 10;
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0);
  int _currentCoverIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchMangaList();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> saveMangaListToCache(
      List<Map<String, dynamic>> mangaList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mangaList', jsonEncode(mangaList));
  }

  Future<List<Map<String, dynamic>>?> getMangaListFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final mangaListString = prefs.getString('mangaList');
    if (mangaListString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(mangaListString));
    }
    return null;
  }

  Future<void> fetchMangaList() async {
    try {
      final cachedMangaList = await getMangaListFromCache();
      if (cachedMangaList != null) {
        _pagingController.itemList = cachedMangaList;
      }

      final newItems = await MangaDexService.getMangaList(
        title: "",
        limit: _pageSize,
        offset: 0,
      );
      _pagingController.itemList = newItems;
      await saveMangaListToCache(newItems);
    } catch (e) {
      print("Error fetching manga list: $e");
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await MangaDexService.getMangaList(
        title: "",
        limit: _pageSize,
        offset: pageKey,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _changeCover(int direction) {
    setState(() {
      _currentCoverIndex =
          (_currentCoverIndex + direction) % _pagingController.itemList!.length;
      if (_currentCoverIndex < 0) {
        _currentCoverIndex = _pagingController.itemList!.length - 1;
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manga List',
          style: TextStyle(color: Color.fromARGB(255, 237, 237, 237)),
        ),
        backgroundColor: const Color(0xFF2C2F33), // Discord dark theme color
        actions: [
          IconButton(
            icon: const Icon(Icons.search,
                color: Color.fromARGB(255, 237, 237, 237)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
      body: PagedListView<int, Map<String, dynamic>>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, manga, index) {
            if (index == 0) {
              final currentManga =
                  _pagingController.itemList![_currentCoverIndex];
              final imageUrl =
                  currentManga['coverUrl'] ?? "https://via.placeholder.com/150";
              final title =
                  currentManga['attributes']['title']?['en'] ?? "Unknown Title";
              final genres =
                  (currentManga['attributes']['tags'] as List<dynamic>)
                      .map((tag) => tag['attributes']['name']['en'] as String)
                      .take(4)
                      .toList();

              return Column(
                children: [
                  // Jumbotron with arrows
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(mangaId: currentManga['id']),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(imageUrl),
                              fit: BoxFit.cover,
                              alignment: Alignment
                                  .topCenter, // Prioritize top part of the image
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                          onPressed: () => _changeCover(-1),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 30),
                          onPressed: () => _changeCover(1),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: const Alignment(
                                  0, -1), // Make the gradient taller
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 4.0,
                                runSpacing: 2.0,
                                children: genres
                                    .take(5) // Limit to 5 genres
                                    .map((genre) => Chip(
                                          label: Text(genre),
                                          backgroundColor:
                                              const Color(0xFF2C2F33),
                                          labelStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Carousel
                  CarouselSlider(
                    options: CarouselOptions(height: 350.0),
                    items: _pagingController.itemList!.map((manga) {
                      final title = manga['attributes']['title']?['en'] ??
                          "Unknown Title";
                      final imageUrl = manga['coverUrl'] ??
                          "https://via.placeholder.com/150";
                      final genres =
                          (manga['attributes']['tags'] as List<dynamic>)
                              .map((tag) =>
                                  tag['attributes']['name']['en'] as String)
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
                          color: const Color(
                              0xFF2C2F33), // Discord dark theme color
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                                alignment: Alignment
                                    .topCenter, // Prioritize top part of the image
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Wrap(
                                      spacing: 4.0,
                                      runSpacing: -10.0,
                                      children: genres
                                          .map((genre) => Chip(
                                                label: Text(genre),
                                                backgroundColor:
                                                    const Color(0xFF2C2F33),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 1.0,
                                                  vertical: 0.0,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            } else {
              // Remaining cards in list
              final manga = _pagingController.itemList![index];
              final title =
                  manga['attributes']['title']?['en'] ?? "Unknown Title";
              final desc =
                  manga['attributes']['description']?['en'] ?? "No Description";
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
                      builder: (context) => DetailScreen(mangaId: manga['id']),
                    ),
                  );
                },
                child: Card(
                  color: const Color(0xFF2C2F33), // Discord dark theme color
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
                                          backgroundColor: const Color.fromARGB(
                                              255, 68, 68, 70),
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
            }
          },
        ),
      ),
    );
  }
}
