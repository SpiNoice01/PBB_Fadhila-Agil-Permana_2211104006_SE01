import 'package:flutter/material.dart';

class DataShowPage extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DataShowPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Show Page'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]['title']),
            subtitle: Text(data[index]['description']),
          );
        },
      ),
    );
  }
}
