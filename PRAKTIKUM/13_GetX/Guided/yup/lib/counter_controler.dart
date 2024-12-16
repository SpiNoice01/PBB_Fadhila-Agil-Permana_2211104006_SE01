import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs; // State yang reaktif
  void increment() => count++;

  void getbottomsheet() {
    Get.bottomSheet(
      Container(
        height: 200,
        color: Colors.amber,
        child: const Center(child: Text("Bottom Sheet")),
      ),
    );
  }
}
