import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z A T I O N - D AT A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // list of all notes in the database
  final List<Note> currentNotes = [];

  // C R E A T E - a note and save it to the database
  Future<void> addNote(String title, String content) async {
    final newNote = Note()
      ..title = title
      ..content = content
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
    });

    await fetchNotes();
  }

  // R E A D - get all notes from the database
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // U P D A T E - update a note in the database
  Future<void> updateNote(int id, String title, String content) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.title = title;
      existingNote.content = content;
      existingNote.updatedAt = DateTime.now();
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // D E L E T E - delete a note from the database
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
