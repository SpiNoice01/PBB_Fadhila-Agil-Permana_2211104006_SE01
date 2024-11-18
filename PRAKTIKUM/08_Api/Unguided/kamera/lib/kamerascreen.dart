import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Kamera extends StatefulWidget {
  const Kamera({super.key});

  @override
  State<Kamera> createState() => _KameraState();
}

class _KameraState extends State<Kamera> {
  File? _image;

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              width: 300,
              height: 300,
              child: _image == null
                  ? const Icon(Icons.image)
                  : Image.file(_image!),
            ),
          ),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: FloatingActionButton(
                  onPressed: _pickImageFromCamera,
                  tooltip: 'Pick Image from Camera',
                  child: const Text("Pick From Cam"),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 150,
                child: FloatingActionButton(
                  onPressed: _pickImageFromGallery,
                  tooltip: 'Pick Image from Gallery',
                  child: const Text('Pick From Gallery'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
