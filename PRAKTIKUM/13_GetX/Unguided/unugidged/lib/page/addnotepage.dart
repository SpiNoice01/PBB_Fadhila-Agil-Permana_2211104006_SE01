import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unugidged/helper/notecontroller.dart';
import 'package:unugidged/models/note.dart';

class AddNotePage extends StatelessWidget {
  final NoteController noteController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                noteController.addNote(note);
                Get.back();
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
