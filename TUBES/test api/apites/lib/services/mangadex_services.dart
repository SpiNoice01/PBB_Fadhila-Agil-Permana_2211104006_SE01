import 'dart:convert';
import 'package:http/http.dart' as http;

class MangaDexService {
  static const String baseUrl = "https://api.mangadex.org";

  // Get list of Manga
  static Future<List<Map<String, dynamic>>> getMangaList(
      {required String title}) async {
    final response = await http
        .get(Uri.parse("$baseUrl/manga?title=$title&includes[]=cover_art"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mangaList = (data['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>

      // Map manga data to include image URL
      return mangaList.map<Map<String, dynamic>>((manga) {
        final relationships = manga['relationships'] as List<dynamic>;
        final coverArt = relationships.firstWhere(
          (rel) => rel['type'] == 'cover_art',
          orElse: () => null,
        ) as Map<String, dynamic>?;

        final coverFileName = coverArt?['attributes']?['fileName'];
        final mangaId = manga['id'];
        final imageUrl = coverFileName != null
            ? "https://uploads.mangadex.org/covers/$mangaId/$coverFileName"
            : null;

        return {
          ...manga,
          'coverUrl': imageUrl, // Add image URL to the manga object
        };
      }).toList();
    } else {
      throw Exception('Failed to load manga');
    }
  }

  // Get chapter pages
  static Future<List<String>> getChapterPages(String chapterId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/at-home/server/$chapterId"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final baseUrl = data['baseUrl'];
      final hash = data['chapter']['hash'];
      final pages = data['chapter']['data'];
      return pages.map<String>((page) => "$baseUrl/data/$hash/$page").toList();
    } else {
      throw Exception('Failed to load chapter pages');
    }
  }

  static Future<Map<String, dynamic>> getMangaDetails(String mangaId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/manga/$mangaId?includes[]=cover_art'));

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        print('Manga Details API Response: ${json.encode(data)}'); // Debugging

        if (data['data'] != null) {
          final mangaData = data['data'];

          // Ensure relationships contains the cover_art
          if (mangaData['relationships'] is List) {
            for (var relationship in mangaData['relationships']) {
              if (relationship['type'] == 'cover_art' &&
                  relationship['attributes']?['fileName'] != null) {
                mangaData['coverUrl'] =
                    "https://uploads.mangadex.org/covers/$mangaId/${relationship['attributes']['fileName']}";
                print('Cover URL: ${mangaData['coverUrl']}'); // Debugging
                break;
              }
            }
          }

          // Fallback if no cover_art found
          mangaData['coverUrl'] ??= "https://via.placeholder.com/300";
          print('Final Cover URL: ${mangaData['coverUrl']}'); // Debugging

          return mangaData;
        }
      } catch (e) {
        throw Exception('Error parsing manga details: $e');
      }
    }

    throw Exception('Failed to load manga details: ${response.reasonPhrase}');
  }
}
