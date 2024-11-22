// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yupi/helper/db_helper.dart'; // Make sure to import your database helper

class DataAddPage extends StatefulWidget {
  const DataAddPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataAddPageState createState() => _DataAddPageState();
}

class _DataAddPageState extends State<DataAddPage> {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hobiController = TextEditingController();

  void _insertData() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'Nama': _namaController.text,
        'NIM': _nimController.text,
        'Alamat': _alamatController.text,
        'Hobi': _hobiController.text,
      };
      try {
        final id = await dbHelper.insert(row);
        print('Inserted row id: $id');
        _titleController.clear();
        _descriptionController.clear();
        _namaController.clear();
        _nimController.clear();
        _alamatController.clear();
        _hobiController.clear();
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        print('Error inserting data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _namaController,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.badge, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _nimController,
                            decoration: const InputDecoration(
                              labelText: 'NIM',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a NIM';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.home, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _alamatController,
                            decoration: const InputDecoration(
                              labelText: 'Alamat',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _hobiController,
                            decoration: const InputDecoration(
                              labelText: 'Hobi',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a hobby';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: _insertData,
                  child: const Text('Add Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
