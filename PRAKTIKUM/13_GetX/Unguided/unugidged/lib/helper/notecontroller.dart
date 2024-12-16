import 'package:get/get.dart';
import 'package:unugidged/models/note.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;

  void addNote(Note note) {
    notes.add(note);
  }

  void deleteNoteAt(int index) {
    notes.removeAt(index);
  }
}
