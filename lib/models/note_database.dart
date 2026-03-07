import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteDatabase {
  static late Isar isar;

  // I N I T I A L I Z A T I O N - D AT A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // list of all notes in the database
  static List<Note> currentNotes = [];

  // C R E A T E - a note and save it to the database
  Future<void> addNote(String textFromUser) async {
    // create a new note object
    final newNote = Note()..text = textFromUser;

    // save the note to the database
    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
    });

    // update the list of notes
  }

  // R E A D - get all notes from the database

  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
  }

  // U P D A T E - update a note in the database
  Future<void> updateNote(int id, String newtext) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newtext;
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
