import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      home: HomeScreen(),
    );
  }
}

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

  Expense({
    required this.id,
    required this.amount,
    required this.category,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  List<Category> categories = [
    Category(
      id: 'c1',
      title: 'Food',
      icon: Icons.fastfood,
      color: Colors.redAccent,
    ),
    Category(
      id: 'c2',
      title: 'Transport',
      icon: Icons.directions_bus,
      color: Colors.green,
    ),
    // Add more categories as needed
  ];

  void _addNewExpense(double amount, Category category) {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      amount: amount,
      category: category,
    );

    setState(() {
      expenses.add(newExpense);
    });
  }

  void _showAddExpenseDialog(BuildContext context, Category category) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount (\$)'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  _addNewExpense(amount, category);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = expenses.fold(0.0, (sum, exp) => sum + exp.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}'),
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
          final categoryExpenses = expenses.where((exp) => exp.category.id == category.id).toList();
          double categoryTotal = categoryExpenses.fold(0.0, (sum, exp) => sum + exp.amount);

          return GestureDetector(
            onTap: () => _showAddExpenseDialog(context, category),
            child: Card(
              color: category.color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(category.icon, size: 40, color: Colors.white),
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
