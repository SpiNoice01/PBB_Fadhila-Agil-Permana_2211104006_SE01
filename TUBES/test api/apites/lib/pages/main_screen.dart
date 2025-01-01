import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';
import 'package:apites/pages/search_manga.dart';
import 'package:apites/pages/favorite_screen.dart'; // Import halaman favorit
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apites/collection/colors.dart'; // Import AppColors

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _pageSize = 10;
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0);
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _popularMangaList = [];
  List<Map<String, dynamic>> _favoriteMangaList = [];

  @override
  void initState() {
    super.initState();
    fetchMangaList();
    fetchPopularManga();
    fetchFavoriteManga();
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

  Future<void> fetchPopularManga() async {
    try {
      final popularManga = await MangaDexService.getPopularManga();
      setState(() {
        _popularMangaList = popularManga;
      });
    } catch (e) {
      print("Error fetching popular manga: $e");
    }
  }

  Future<void> fetchFavoriteManga() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedMangaIds = prefs.getStringList('likedManga') ?? [];
      List<Map<String, dynamic>> favoriteManga = [];
      for (String id in likedMangaIds) {
        final manga = await MangaDexService.getMangaDetails(id);
        favoriteManga.add(manga);
      }
      setState(() {
        _favoriteMangaList = favoriteManga;
      });
    } catch (e) {
      print("Error fetching favorite manga: $e");
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

  Future<void> toggleFavorite(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    if (likedManga.contains(mangaId)) {
      likedManga.remove(mangaId);
    } else {
      likedManga.add(mangaId);
    }
    await prefs.setStringList('likedManga', likedManga);
    setState(() {
      fetchFavoriteManga(); // Refresh favorite manga list
    });
  }

  Future<bool> isFavorite(String mangaId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedManga = prefs.getStringList('likedManga') ?? [];
    return likedManga.contains(mangaId);
  }

  String truncateTitle(String title, int wordLimit) {
    List<String> words = title.split(' ');
    if (words.length > wordLimit) {
      return '${words.sublist(0, wordLimit).join(' ')}...';
    }
    return title;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'lib/assets/mangaDex.svg', // Path to your SVG asset
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'MangaDex',
              style: TextStyle(color: Color.fromARGB(255, 237, 237, 237)),
            ),
          ],
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
          IconButton(
            icon: const Icon(Icons.favorite,
                color: AppColors.mangaDex), // Gunakan AppColors
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward,
                color: Color.fromARGB(255, 237, 237, 237)),
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
      body: PagedListView<int, Map<String, dynamic>>(
        pagingController: _pagingController,
        scrollController: _scrollController,
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, manga, index) {
            if (index == 0) {
              return Column(
                children: [
                  // Redesigned Jumbotron with CarouselSlider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      autoPlay: true,
                      autoPlayInterval:
                          const Duration(seconds: 50), // Durasi antar slide
                      autoPlayAnimationDuration:
                          const Duration(seconds: 5), // Durasi animasi transisi
                      enlargeCenterPage: true,
                      viewportFraction: 1.0, // Make the image take full width
                      onPageChanged: (index, reason) {
                        setState(() {});
                      },
                    ),
                    items: _pagingController.itemList!.map((manga) {
                      final imageUrl = manga['coverUrl'] ??
                          "https://via.placeholder.com/150";
                      final title = manga['attributes']['title']?['en'] ??
                          "Unknown Title";
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
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(imageUrl),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
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
                                    end: const Alignment(0, -1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 4.0,
                                      runSpacing: 2.0,
                                      children: genres
                                          .take(5)
                                          .map((genre) => Chip(
                                                label: Text(genre),
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.5),
                                                labelStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                      );
                    }).toList(),
                  ),
                  // Carousel for popular manga
                  CarouselSlider(
                    options: CarouselOptions(height: 350.0),
                    items: _popularMangaList.map((manga) {
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
                        child: Stack(
                          children: [
                            Card(
                              color: const Color(0xFF2C2F33),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.5),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: const Text(
                                  'Popular',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  // Horizontal list for favorite manga
                  if (_favoriteMangaList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Your Favorites',
                            style: TextStyle(
                              color: Color.fromARGB(255, 226, 226, 226),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _favoriteMangaList.length,
                            itemBuilder: (context, index) {
                              final manga = _favoriteMangaList[index];
                              final title = manga['attributes']['title']
                                      ?['en'] ??
                                  "Unknown Title";
                              final truncatedTitle = truncateTitle(title, 2);
                              final imageUrl = manga['coverUrl'] ??
                                  "https://via.placeholder.com/150";

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
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                                Icons.image_not_supported),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          truncatedTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Just Uploaded',
                            style: TextStyle(
                              color: Color.fromARGB(255, 226, 226, 226),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
                              const SizedBox(height: 8),
                              FutureBuilder<bool>(
                                future: isFavorite(manga['id']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    final isFav = snapshot.data ?? false;
                                    return IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isFav ? Colors.red : Colors.white,
                                      ),
                                      onPressed: () =>
                                          toggleFavorite(manga['id']),
                                    );
                                  }
                                },
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
