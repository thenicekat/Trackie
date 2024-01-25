import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:trackie/Models/ExpenseModel.dart';
import 'package:trackie/Models/SubjectModel.dart';

class DatabaseProvider {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, itemName VARCHAR(100), moneySpent INTEGER)');
        await database.execute(
            'CREATE TABLE Subjects (id INTEGER PRIMARY KEY AUTOINCREMENT, subject VARCHAR(100) UNIQUE, sem VARCHAR(100), credits INTEGER, grade INTEGER)');
      },
      version: 1,
    );
  }

  // Subjects
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

  Future<int> findSGPA(String sem) async {
    final Database db = await initializeDB();
    final List<Map> sumTotalCredits = await db
        .rawQuery('SELECT sum(credits) FROM Subjects WHERE sem = "$sem"');
    final List<Map> sumTotalGrade = await db.rawQuery(
        'SELECT sum(grade * credits) FROM Subjects WHERE sem = "$sem"');
    int sumCredits = sumTotalCredits[0]["sum(credits)"] ?? 0;
    int sumGrade = sumTotalGrade[0]["sum(grade * credits)"] ?? 0;
    int sgpa = sumGrade ~/ sumCredits;
    return sgpa;
  }

  Future<int> findCGPA() async {
    final Database db = await initializeDB();
    final List<Map> sumTotalCredits =
        await db.rawQuery('SELECT sum(credits) FROM Subjects');
    final List<Map> sumTotalGrade =
        await db.rawQuery('SELECT sum(grade * credits) FROM Subjects');
    int sumCredits = sumTotalCredits[0]["sum(credits)"] ?? 0;
    int sumGrade = sumTotalGrade[0]["sum(grade * credits)"] ?? 0;
    int cgpa = sumGrade ~/ sumCredits;
    return cgpa;
  }

  // Expenses
  Future<int> addExpense(ExpenseModel expenseModel) async {
    final Database db = await initializeDB();
    final id = await db.insert('Expenses', expenseModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<ExpenseModel>> retrieveExpenses() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Expenses');
    return queryResult.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<int> getTotalSpent() async {
    final Database db = await initializeDB();
    final List<Map> sumTotalExpense =
        await db.rawQuery('SELECT sum(moneySpent) FROM Expenses');
    int sum = sumTotalExpense[0]["sum(moneySpent)"] ?? 0;
    return sum;
  }

  Future<int> deleteExpense(int id) async {
    final Database db = await initializeDB();
    int count = await db.delete('Expenses', where: 'id = ?', whereArgs: [id]);
    await db
        .execute('UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = "Expenses"');
    return count;
  }

  Future<int> truncateExpenses() async {
    final Database db = await initializeDB();
    await db.execute('DELETE FROM Expenses');
    await db
        .execute('UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = "Expenses"');
    return 0;
  }
}
