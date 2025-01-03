import 'package:cots/design_system/colors_collection.dart';
import 'package:cots/modules/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> countryCodes = [
    {'code': 'ID', 'dial_code': '+62', 'flag': '🇮🇩'},
    {'code': 'US', 'dial_code': '+1', 'flag': '🇺🇸'},
    {'code': 'IN', 'dial_code': '+91', 'flag': '🇮🇳'},
    {'code': 'CN', 'dial_code': '+86', 'flag': '🇨🇳'},
    {'code': 'JP', 'dial_code': '+81', 'flag': '🇯🇵'},
    // Tambahkan negara lain jika diperlukan
  ];
  String selectedCountryCode = '+62';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('lib/assets/logo.png',
              height: 40), // Ganti dengan path logo Anda
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered phone number to log in',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedCountryCode,
                    items: countryCodes.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['dial_code'],
                        child: Row(
                          children: [
                            Text(country['flag']!),
                            const SizedBox(width: 8),
                            Text(country['dial_code']!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountryCode = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          TextInputType.phone, // Set keyboard type to phone
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Navigasi ke MainPage tanpa validasi nomor telepon
              Get.to(const MainPage());
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: ColorCollection.color9, // Foreground (text) color
            minimumSize: const Size.fromHeight(50), // Adjust height
          ),
          child: const Text('Masuk'),
        ),
      ),
    );
  }
}
