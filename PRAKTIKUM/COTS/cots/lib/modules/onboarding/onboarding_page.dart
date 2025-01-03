import 'package:cots/design_system/colors_collection.dart';
import 'package:cots/modules/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import ColorCollection

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 40.0), // Add gap to the left
          child: Image.asset(
            'lib/assets/logo.png',
            width: 200, // Adjust the width as needed
            height: 200, // Adjust the height as needed
          ), // Ganti dengan path logo Anda
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                OnboardingSlide(
                  imagePath: 'lib/assets/1.png',
                  title: 'Selamat Datang di Gojek!',
                  description: 'Aplikasi yang bikin hidupmu lebih nyaman. Siap '
                      'bantuin semua kebutuhanmu, kapanpun, dan di manapun.',
                ),
                OnboardingSlide(
                  imagePath: 'lib/assets/2.png',
                  title: 'Transportasi & logistik',
                  description: 'Antarin kamu jalan atau ambilin barang lebih '
                      'gampang tinggal ngeklik doang~',
                ),
                OnboardingSlide(
                  imagePath: 'lib/assets/3.png',
                  title: 'Pesan Makan & Belanja',
                  description:
                      'Lagi ngidam sesuatu? Gojek beliin gak pakai lama.',
                ),
                OnboardingSlide(
                  imagePath: 'lib/assets/4.png',
                  title: 'Nikmati Kemudahan',
                  description:
                      'Gojek memberikan kemudahan dalam berbagai aspek kehidupan.',
                ),
                OnboardingSlide(
                  imagePath: 'lib/assets/5.png',
                  title: 'Layanan Terbaik',
                  description:
                      'Kami selalu berusaha memberikan layanan terbaik untuk Anda.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Add gap above the page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 12.0,
                width: _currentPage == index ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.grey,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(const LoginPage());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        ColorCollection.color9, // Foreground (text) color
                    minimumSize: const Size.fromHeight(50), // Adjust height
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Adjust padding
                  ),
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    // Navigasi ke halaman register
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorCollection.color8,
                    backgroundColor: Colors.white, // Background color
                    side: const BorderSide(
                        color: ColorCollection.color8), // Outline color
                    minimumSize: const Size.fromHeight(50), // Adjust height
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Adjust padding
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dengan masuk atau mendaftar, kamu menyetujui\nKetentuan layanan dan Kebijakan privasi.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingSlide({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the slide
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
