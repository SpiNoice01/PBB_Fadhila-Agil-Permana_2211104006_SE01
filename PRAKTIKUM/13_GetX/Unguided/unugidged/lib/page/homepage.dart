import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unugidged/helper/notecontroller.dart';
import 'package:unugidged/page/addnotepage.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: noteController.notes.length,
          itemBuilder: (context, index) {
            final note = noteController.notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  noteController.deleteNoteAt(index);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddNotePage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
