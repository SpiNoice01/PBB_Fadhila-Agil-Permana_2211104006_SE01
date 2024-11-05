import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String data;

  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    String data = 'Hello from MyPage';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(data: data),
              ),
            );
          },
          child: const Text('Go to Detail Page'),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyPage(),
  ));
}