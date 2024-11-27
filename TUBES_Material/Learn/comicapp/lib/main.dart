import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase safely
  try {
    await Firebase.initializeApp(
      options: Platform.isIOS || Platform.isMacOS
          ? const FirebaseOptions(
              appId: 'IOS_KEY',
              apiKey: 'AIzaSyAm_np2W90IG2UD77eyhFUHdraWHjtIwW4',
              projectId: 'comicapp-286b3',
              messagingSenderId: '546354813330',
              databaseURL: 'https://comicapp-286b3.firebaseio.com',
            )
          : const FirebaseOptions(
              appId: '1:546354813330:android:cc4efcdfe8b0b3e6b8894b',
              apiKey: 'AIzaSyAm_np2W90IG2UD77eyhFUHdraWHjtIwW4',
              projectId: 'comicapp-286b3',
              messagingSenderId: '546354813330',
              databaseURL: 'https://comicapp-286b3.firebaseio.com',
            ),
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow; // Re-throw non-duplicate errors
    }
  }

  runApp(MyApp(app: Firebase.app()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.app});

  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comic Banners',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BannerCarousel(),
    );
  }
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late DatabaseReference _bannersRef;
  late Future<List<String>> _bannerImages;

  @override
  void initState() {
    super.initState();
    // Reference to the 'Banners' node in Firebase Database
    _bannersRef = FirebaseDatabase.instance.ref().child('Banners');
    _bannerImages = fetchBannerImages();
  }

  Future<List<String>> fetchBannerImages() async {
    int retryCount = 0;
    const int maxRetries = 5;
    const Duration initialDelay = Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        final DataSnapshot snapshot = await _bannersRef.get();
        if (!snapshot.exists) {
          debugPrint('No banners found in the database.');
          return [];
        }

        // Retrieve the list of banner URLs
        final List<dynamic> data = snapshot.value as List<dynamic>;
        List<String> urls = data.cast<String>();

        debugPrint('Fetched URLs: $urls'); // Debug print for fetched URLs
        return urls;
      } catch (e) {
        if (e is FirebaseException && e.code == 'too-many-requests') {
          retryCount++;
          final delay = initialDelay * retryCount;
          debugPrint('Retrying in $delay seconds...');
          await Future.delayed(delay);
        } else {
          debugPrint('Error fetching banners: $e');
          return [];
        }
      }
    }

    debugPrint('Max retries reached. Could not fetch banners.');
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comic Banners'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<String>>(
        future: _bannerImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No banners available.'));
          }

          // Display the carousel with the fetched images
          return CarouselSlider(
            items: snapshot.data!.map((url) {
              return Builder(
                builder: (context) {
                  debugPrint('Rendering image: $url');
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                    ),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading image: $url, Error: $error');
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.red,
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 16 / 9,
              initialPage: 0,
            ),
          );
        },
      ),
    );
  }
}
