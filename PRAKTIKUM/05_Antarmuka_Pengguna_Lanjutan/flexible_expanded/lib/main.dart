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
        appBar: AppBar(
          title: const Text('Flexible vs Expanded'),
        ),
        body: const FlexibleExpanded(),
      ),
    );
  }
}

class FlexibleExpanded extends StatelessWidget {
  const FlexibleExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 50,
              height: 100,
              color: Colors.red,
            ),
            Flexible(
              child: Container(
                height: 100,
                color: Colors.green,
                child: const Text(
                  "Flexible takes up the remaining space but can shrink if needed.",
                ),
              ),
            ),
            const Icon(Icons.sentiment_very_satisfied),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 50,
              height: 100,
              color: Colors.red,
            ),
            Expanded(
              child: Container(
                height: 100,
                color: Colors.green,
                child: const Text(
                  "Expanded forces the widget to take up all the remaining space.",
                ),
              ),
            ),
            const Icon(Icons.sentiment_very_satisfied),
          ],
        ),
      ],
    );
  }
}
