import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yup/counter_controler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());
    return Scaffold(
      appBar: AppBar(title: const Text('GetX State Management')),
      body: Center(
        child: Obx(() => Text(
              'Counter: ${controller.count}',
              style: const TextStyle(fontSize: 25),
            )),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: controller.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: controller.getbottomsheet,
            tooltip: 'Get Bottom Sheet',
            child: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
