import 'package:expense_tracker/home_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';

class DatabaseHandler {
  static final DatabaseHandler _instance = new DatabaseHandler.internal();
  factory DatabaseHandler() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  DatabaseHandler.internal();

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "main.db";
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Expense(id TEXT PRIMARY KEY, amount REAL, categoryId TEXT, date TEXT)");
    print("Table is created");
  }

  // Insertion
  Future<int?> saveExpense(Expense expense) async {
    var dbClient = await db;
    int? res = await dbClient!.insert("Expense", {
      'id': expense.id,
      'amount': expense.amount,
      'categoryId': expense.category.id,
      'date': expense.date.toIso8601String(),
    });
    return res;
  }

  // Get Expenses
Future<List<Expense>> getExpenses(List<Category> categories) async {
  var dbClient = await db;
  List<Map> list = await dbClient!.rawQuery('SELECT * FROM Expense');
  List<Expense> expenses = []; // Changed this line
  for (int i = 0; i < list.length; i++) {
    var expense = new Expense(
      id: list[i]["id"],
      amount: list[i]["amount"],
      category: categories.firstWhere((category) => category.id == list[i]["categoryId"]),
      date: DateTime.parse(list[i]["date"]),
    );
    expenses.add(expense);
  }
  return expenses;
}

  // Deletion
  Future<int> deleteExpense(String id) async {
    var dbClient = await db;
    return await dbClient!.delete("Expense", where: 'id = ?', whereArgs: [id]);
  }

  // Updation
  Future<int> updateExpense(Expense expense) async {
    var dbClient = await db;
    return await dbClient!.update("Expense", {
      'id': expense.id,
      'amount': expense.amount,
      'categoryId': expense.category.id,
      'date': expense.date.toIso8601String(),
    }, where: "id = ?", whereArgs: [expense.id]);
  }
}