import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Changed to StatelessWidget as no state is being managed
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Wisata Bandung'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            color: Colors.blue,
            margin: const EdgeInsets.all(100),
            padding: const EdgeInsets.all(50),
            child: Column(
              // Center the content vertically
              children: [
                const Text(
                  'Daikoku Parking Lot',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Add space between text and image
                Image.network(
                  "https://media-cdn.tripadvisor.com/media/attractions-splice-spp-674x446/11/f9/c4/b5.jpg",
                  width: 300,
                ),
                const SizedBox(height: 20), // Add space between image and text
                const Text(
                  "Daikoku Parking Area adalah tempat pertemuan terkenal di Tokyo untuk para penggemar mobil. Dikenal dengan suasana ramah dan berbagai kendaraan, termasuk supercar, mobil sport, dan JDM. Terletak di pulau buatan di Teluk Tokyo, tempat ini ramai dikunjungi pada Jumat dan Sabtu malam.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    const url =
                        'https://www.tripadvisor.com/AttractionProductReview-g1066456-d26159989-TOKYO_PREMIUM_CAR_TOUR_Daikoku_PA_Japan_s_Amazing_JDM_Car_Meet-Shibuya_Tokyo_Toky.html';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text('Go to Daikoku Parking Lot Tour'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
