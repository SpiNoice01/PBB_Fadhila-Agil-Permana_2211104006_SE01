import 'package:flutter/material.dart';
import 'package:widget/reuasble/styles/collor_collections.dart';
import 'package:widget/reuasble/styles/spacing_collections.dart';
import 'package:widget/reuasble/styles/tipografi.dart';
import 'package:widget/reuasble/widgets/buttons/custombutt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Widget',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Widget'),
            titleTextStyle: TextStyle(color: CollorCollections.accentRed),
            backgroundColor: CollorCollections.graying,
            shadowColor: Colors.red,
          ),
          body: Column(
            children: [
              Text("Hello",
                  style: Tipografi.title
                      .copyWith(color: CollorCollections.accentRed)),
              const SizedBox(height: SpacingCollections.xl),
              Text(
                "MIAWWWW",
                style: TextStyle(color: CollorCollections.accentGreen),
              ),
              cusbutt(color: CollorCollections.accentGreen),
            ],
          ),
        ));
  }
}
