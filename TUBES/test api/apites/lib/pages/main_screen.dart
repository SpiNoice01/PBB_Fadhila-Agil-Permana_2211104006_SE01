import 'package:flutter/material.dart';
import 'package:apites/services/mangadex_services.dart';
import 'package:apites/pages/detail_screen.dart';
import 'package:apites/pages/search_manga.dart'; // Import the new search screen
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _pageSize = 10;
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
      body: PagedListView<int, Map<String, dynamic>>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, manga, index) {
            // Extract manga details
            final title =
                manga['attributes']['title']?['en'] ?? "Unknown Title";
            final desc =
                manga['attributes']['description']?['en'] ?? "No Description";
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
                title:
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle:
                    Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(mangaId: manga['id']),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
