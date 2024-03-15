import 'package:expense_tracker/data_base.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Category {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class Expense {
  final String id;
  final double amount;
  final Category category;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler();
  List<Expense> expenses = [];
  List<Category> categories = [
    Category(
      id: 'c1',
      title: 'Food',
      icon: Icons.fastfood,
      color: Colors.black54,
    ),
    Category(
      id: 'c2',
      title: 'Gas',
      icon: Icons.car_crash,
      color: Colors.black54,
    ),
    Category(
      id: 'c3',
      title: 'Housing & Utilities',
      icon: Icons.house,
      color: Colors.black54,
    ),
    Category(
      id: 'c4',
      title: 'Entertainment',
      icon: Icons.videogame_asset,
      color: Colors.black54,
    ),
    Category(
      id: 'c5',
      title: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.black54,
    ),
    Category(
      id: 'c6',
      title: 'Credit Cards',
      icon: Icons.add_card,
      color: Colors.black54,
    ),
  ];
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _saveCategoriesIfNeeded();
    _loadExpenses();
  }
  void _saveCategoriesIfNeeded() async {
  final existingCategories = await dbHandler.getCategories();
  if (existingCategories.isEmpty) {
    for (final category in categories) {
      await dbHandler.saveCategory(category);
    }
  }
}

  void _loadExpenses() async {
    var loadedExpenses = await dbHandler.getExpenses(categories);
    setState(() {
      expenses = loadedExpenses ?? [];
    });
  }

  void _addNewExpense(double amount, Category category, DateTime date) async {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      amount: amount,
      category: category,
      date: date,
    );

    await dbHandler.saveExpense(newExpense);
    _loadExpenses();
  }

  void _showAddExpenseDialog(BuildContext context, Category category) {
    final TextEditingController amountController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(

          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount (\$)'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Selected date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today,color: Colors.black,),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Add',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      _addNewExpense(amount, category, _selectedDate);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: Text('Reset Expenses',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await dbHandler.deleteExpensesByCategory(category.id);
                    Navigator.of(context).pop();
                    _loadExpenses(); 
              }
              ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double monthlyExpenses = expenses
        .where((exp) => exp.date.month == currentMonth.month && exp.date.year == currentMonth.year)
        .fold(0.0, (sum, exp) => sum + exp.amount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                  _loadExpenses(); 
                });
              },
            ),
            Text('${DateFormat.yMMM().format(currentMonth)}: \$${monthlyExpenses.toStringAsFixed(2)}'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                  _loadExpenses(); 
                });
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryExpenses = expenses.where((exp) => exp.category.id == category.id && exp.date.month == currentMonth.month && exp.date.year == currentMonth.year).toList();
          double categoryTotal = categoryExpenses.fold(0.0, (sum, exp) => sum + exp.amount);

          return GestureDetector(
            onTap: () => _showAddExpenseDialog(context, category),
            child: Card(
              color: category.color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(category.icon, size: 40, color: Colors.white),
                    Container(height: 1,width: 1,),
                    Container(height: 1,width: 1,),
                    Text(
                      category.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Total: \$${categoryTotal.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}