import 'package:flutter/material.dart';
import 'package:yupi/helper/db_helper.dart';

class SecondScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('isian Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final row = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(row['nama']),
                    subtitle:
                        Text('NIM: ${row['nim']}, Kelas: ${row['kelas']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
