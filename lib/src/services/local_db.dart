import 'package:SwiftNotes/src/model/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class LocalDBService {
  late Future<Isar> db;

  LocalDBService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final isarDirectory = appDocDir.path;

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [NoteSchema],
        inspector: true,
        directory: isarDirectory,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveNote({required Note note}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.notes.putSync(note));
  }

  Stream<List<Note>> listenAllNotes() async* {
    final isar = await db;
    yield* isar.notes.where().watch(fireImmediately: true);
  }

  void deleteNote({required int id}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.notes.deleteSync(id));
  }
}
