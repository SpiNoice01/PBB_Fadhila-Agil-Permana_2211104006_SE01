import 'package:flutter/material.dart';

class Judul extends StatelessWidget {
  const Judul({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Selamat Datang, ....',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 231, 231, 231),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
        Text(
          'Ini Aplikasi Ala2 buat latihan & Tugas Unguided.',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 231, 231, 231),
          ),
        ),
      ],
    );
  }
}
