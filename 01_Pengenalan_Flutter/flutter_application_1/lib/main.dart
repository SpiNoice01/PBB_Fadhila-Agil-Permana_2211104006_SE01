import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: const Icon(Icons.menu),
          title: const Center(
            child: Text(
              "BIODATA",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "img/Agil.jpg",
              width: 200.0,
              height: 200.0,
            ),
            const Text(
              "NAMA : Fadhila Agil Permana\nNIM : 2211104006",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Jenis Kelamin : Laki-Laki",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Tanggal Lahir : 8 Juli 2005",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Asal : Cirebon",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
