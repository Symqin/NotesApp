import 'package:flutter/material.dart';
import 'package:notes/pages/notes_page.dart';
import 'models/note_database.dart';

void main() {
  // initialize the database before running the app
  WidgetsFlutterBinding.ensureInitialized();
  NoteDatabase.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NotesPage());
  }
}
