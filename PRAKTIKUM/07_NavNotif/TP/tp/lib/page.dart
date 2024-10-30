import 'package:flutter/material.dart';

class Pageku extends StatelessWidget {
  const Pageku({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page'),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "MEAW",
            style: TextStyle(fontSize: 50),
          )
        ],
      ),
    );
  }
}
