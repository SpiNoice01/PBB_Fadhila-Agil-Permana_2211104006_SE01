import 'dart:convert';
import 'package:http/http.dart' as http;

class MangaDexService {
  static const String baseUrl = "https://api.mangadex.org";

  // Get list of Manga
  static Future<List<dynamic>> getMangaList({required String title}) async {
    final response = await http.get(Uri.parse("$baseUrl/manga?title=$title"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // List of manga objects
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
    final response = await http.get(Uri.parse('$baseUrl/manga/$mangaId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load manga details');
    }
  }

  // // Get chapter pages
  // static Future<List<String>> getChapterPages(String chapterId) async {
  //   final client = createHttpClient();
  //   final request =
  //       await client.getUrl(Uri.parse("$baseUrl/at-home/server/$chapterId"));
  //   final response = await request.close();
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.transform(utf8.decoder).join();
  //     final data = json.decode(responseBody);
  //     final baseUrl = data['baseUrl'];
  //     final hash = data['chapter']['hash'];
  //     final pages = data['chapter']['data'];
  //     return pages.map<String>((page) => "$baseUrl/data/$hash/$page").toList();
  //   } else {
  //     throw Exception('Failed to load chapter pages');
  //   }
  // }
}
