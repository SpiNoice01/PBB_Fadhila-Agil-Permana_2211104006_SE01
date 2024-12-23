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

  //read : get all notes
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // Update : update a note
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete : delete a note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
