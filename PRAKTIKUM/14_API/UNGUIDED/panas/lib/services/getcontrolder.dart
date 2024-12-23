import 'package:get/get.dart';
import 'package:panas/services/api_services.dart';

class HomeController extends GetxController {
  var posts = <dynamic>[].obs;
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();

  void showSnackBar(String message) {
    Get.snackbar('Info', message, snackPosition: SnackPosition.TOP);
  }

  Future<void> handleApiOperation(Future<void> operation, String successMessage) async {
    isLoading.value = true;
    try {
      await operation;
      posts.value = _apiService.posts;
      showSnackBar(successMessage);
    } catch (e) {
      showSnackBar('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchPosts() => handleApiOperation(_apiService.fetchPosts(), 'Data berhasil diambil!');
  void createPost() => handleApiOperation(_apiService.createPost(), 'Data berhasil ditambahkan!');
  void updatePost() => handleApiOperation(_apiService.updatePost(), 'Data berhasil diperbarui!');
  void deletePost() => handleApiOperation(_apiService.deletePost(), 'Data berhasil dihapus!');
}