import 'package:flutter/material.dart';
import 'package:tp/page.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Flutter Demo',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Row(
        children: [
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              child: const Text('Open route'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pageku()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
