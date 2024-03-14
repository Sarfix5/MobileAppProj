import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Assuming the following imports correctly point to your models.
// If not, adjust the import paths to correctly locate your Category and Expense models.
import 'package:expense_tracker/home_screen.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler.internal();
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
    String path = "${directory.path}/main.db";
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Expense(id TEXT PRIMARY KEY, amount REAL, categoryId TEXT, date TEXT)");
    await db.execute(
        "CREATE TABLE Category(id TEXT PRIMARY KEY, title TEXT, icon INTEGER, color INTEGER)");
    await _addInitialCategories(db);
  }

  Future<void> _addInitialCategories(Database db) async {
    List<Map<String, dynamic>> initialCategories = [
      {'id': 'c1', 'title': 'Food', 'icon': Icons.fastfood.codePoint, 'color': Colors.black54.value},
      {'id': 'c2', 'title': 'Gas', 'icon': Icons.car_crash.codePoint, 'color': Colors.black54.value},
      {'id': 'c3', 'title': 'Housing & Utilities', 'icon': Icons.house.codePoint, 'color': Colors.black54.value},
      {'id': 'c4', 'title': 'Entertainment', 'icon': Icons.videogame_asset.codePoint, 'color': Colors.black54.value},
      {'id': 'c5', 'title': 'Shopping', 'icon': Icons.shopping_bag.codePoint, 'color': Colors.black54.value},
      {'id': 'c6', 'title': 'Credit Cards', 'icon': Icons.add_card.codePoint, 'color': Colors.black54.value},
    ];

    for (var category in initialCategories) {
      await db.insert("Category", category);
    }
  }

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

  Future<int?> saveCategory(Category category) async {
    var dbClient = await db;
    int? res = await dbClient!.insert("Category", {
      'id': category.id,
      'title': category.title,
      'icon': category.icon.codePoint,
      'color': category.color.value,
    });
    return res;
  }

  
  // Get Expenses
  Future<List<Expense>> getExpenses(List<Category> categories) async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Expense');
    List<Expense> expenses = [];
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
  
  // Get Categories
  Future<List<Category>> getCategories() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Category');
    List<Category> categories = [];
    for (int i = 0; i < list.length; i++) {
      var category = new Category(
        id: list[i]["id"],
        title: list[i]["title"],
        icon: IconData(list[i]["icon"], fontFamily: 'MaterialIcons'),
        color: Color(list[i]["color"]),
      );
      categories.add(category);
    }
    return categories;
  }

  // Deletion
  Future<int> deleteExpense(String id) async {
    var dbClient = await db;
    return await dbClient!.delete("Expense", where: 'id = ?', whereArgs: [id]);
  }

  // Update
  Future<int> updateExpense(Expense expense) async {
    var dbClient = await db;
    return await dbClient!.update("Expense", {
      'id': expense.id,
      'amount': expense.amount,
      'categoryId': expense.category.id,
      'date': expense.date.toIso8601String(),
    }, where: "id = ?", whereArgs: [expense.id]);
  }

  // Reset
  Future<int> deleteExpensesByCategory(String categoryId) async {
    var dbClient = await db;
    return await dbClient!.delete("Expense", where: 'categoryId = ?', whereArgs: [categoryId]);
  }

  // New method to aggregate expenses by category
  Future<List<Map<String, dynamic>>> getAggregatedExpensesByCategory() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('''
      SELECT c.title, SUM(e.amount) as totalAmount
      FROM Expense e
      INNER JOIN Category c ON e.categoryId = c.id
      GROUP BY c.title
    ''');

    // Converting the query result into a List<Map<String, dynamic>> for easier usage in Flutter widgets
    List<Map<String, dynamic>> aggregatedExpenses = list.map((item) => {
      "title": item["title"],
      "totalAmount": item["totalAmount"],
    }).toList();

    return aggregatedExpenses;
  }



}
