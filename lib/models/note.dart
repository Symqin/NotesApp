import 'package:isar/isar.dart';

// Run the command below to generate the note.g.dart file:
// flutter pub run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}
