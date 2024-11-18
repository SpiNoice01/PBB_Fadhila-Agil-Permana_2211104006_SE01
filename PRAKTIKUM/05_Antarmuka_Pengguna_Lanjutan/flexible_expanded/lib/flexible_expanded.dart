import 'package:flutter/material.dart';

class FlexibleExpanded extends StatelessWidget {
  const FlexibleExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexible Expanded'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Container(
            width: 50,
            height: 100,
            color: Colors.red,
          ),
          Container(
            height: 100,
            color: Colors.green,
          ),
          Flexible(
              child: Container(
            height: 100,
            color: Colors.yellow,
            child: const Text('Hello'),
          ))
        ],
      ),
    );
  }
}
