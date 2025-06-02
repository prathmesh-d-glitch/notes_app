import 'dart:async';
import 'package:get/get.dart';
import 'package:notes_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NoteService extends GetxService {
  late Database _db;

  Future<NoteService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'notes.db');

    _db = await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS notes');
        await _createTables(db);
      },
    );
    return this;
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        labels TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<List<Note>> getNotes() async {
    final maps = await _db.query('notes');
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> addNote(Note note) async {
    await _db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note note) async {
    await _db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    await _db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
