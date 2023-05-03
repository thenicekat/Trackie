import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackie/Models/ExpenseModel.dart';

class ExpenseProvider{
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, place VARCHAR(100), itemName VARCHAR(100), moneySpent INTEGER)'
        );
      },
      version: 1,
    );
  }

  Future<int> addExpense(ExpenseModel expenseModel) async {
    final Database db = await initializeDB();
    final id = await db.insert('Expenses', expenseModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<ExpenseModel>> retrieveExpenses() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Expenses');
    return queryResult.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<int> getTotalSpent() async {
    final Database db = await initializeDB();
    final List<Map> sumTotalExpense = await db.rawQuery('SELECT sum(moneySpent) FROM Expenses');
    int sum = sumTotalExpense[0]["sum(moneySpent)"] ?? 0;
    return sum;
  }

  Future<int> deleteExpense(int id) async {
    final Database db = await initializeDB();
    int count = await db.delete('Expenses', where: 'id = ?', whereArgs: [id]);
    return count;
  }
}