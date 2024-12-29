import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apites/pages/detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteMangaIds = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMangaIds = prefs.getStringList('likedManga') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFF2C2F33), // Discord dark theme color
      ),
      backgroundColor: const Color(0xFF23272A), // Discord dark theme color
      body: ListView.builder(
        itemCount: favoriteMangaIds.length,
        itemBuilder: (context, index) {
          final mangaId = favoriteMangaIds[index];
          return ListTile(
            title: Text(
              'Manga ID: $mangaId',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(mangaId: mangaId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
