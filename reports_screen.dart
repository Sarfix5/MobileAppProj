import 'package:flutter/material.dart';
// Import your chart widget and models

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Center(
        child: Text('Expense Charts'),
        // Replace Text widget with your ExpenseChart widget once you have your data
      ),
    );
  }
}
