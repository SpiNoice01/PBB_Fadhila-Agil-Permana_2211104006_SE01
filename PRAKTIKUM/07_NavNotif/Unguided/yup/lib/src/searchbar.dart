import 'package:flutter/material.dart';

class SearchBarOutline extends StatelessWidget {
  const SearchBarOutline({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 150, 150, 150),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Cari Barang",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
