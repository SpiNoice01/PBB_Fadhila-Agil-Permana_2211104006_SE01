import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get colection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Create : add a note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // Update : update a note

  // Delete : delete a note
}
