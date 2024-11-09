// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class cusbutt extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  final double height;
  final dynamic icon;
  const cusbutt(
      {super.key,
      this.label = "MUAWWW",
      this.color = Colors.white,
      this.width = 100,
      this.height = 50,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
    );
  }
}
