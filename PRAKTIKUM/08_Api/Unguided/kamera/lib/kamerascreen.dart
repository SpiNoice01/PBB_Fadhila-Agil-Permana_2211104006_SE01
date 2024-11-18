import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
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
          const SizedBox(height: 100),
          Center(
            child: DottedBorder(
              padding: const EdgeInsets.all(20),
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              color: const Color.fromARGB(255, 148, 148, 148),
              strokeWidth: 10,
              child: SizedBox(
                width: 300,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: _image == null
                      ? const Icon(Icons.image, size: 100)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.amberAccent,
                  onPressed: _pickImageFromCamera,
                  tooltip: 'Pick Image from Camera',
                  child: const Text("Pick From Cam"),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 140,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.amberAccent,
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
