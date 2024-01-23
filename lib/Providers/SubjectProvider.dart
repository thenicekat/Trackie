import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:trackie/Models/SubjectModel.dart';

class SubjectProvider {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE Subjects (id INTEGER PRIMARY KEY AUTOINCREMENT, subject VARCHAR(100), sem VARCHAR(100), credits INTEGER, midsemGrade INTEGER, finalGrade INTEGER)');
      },
      version: 1,
    );
  }

  Future<int> addSubject(SubjectModel subjectModel) async {
    final Database db = await initializeDB();
    final id = await db.insert('Subjects', subjectModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<SubjectModel>> retrieveSubjects(String sem) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM Subjects WHERE sem = "$sem"');
    return queryResult.map((e) => SubjectModel.fromMap(e)).toList();
  }
}
