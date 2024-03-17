import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Set Budget Goals'),
            onTap: () {
              _showBudgetDialog(context);
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Budget Goals'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildBudgetTextField('Food (\$)'),
                _buildBudgetTextField('Gas (\$)'),
                _buildBudgetTextField('Housing & Utilities (\$)'),
                _buildBudgetTextField('Entertainment (\$)'),
                _buildBudgetTextField('Shopping (\$)'),
                _buildBudgetTextField('Credit Cards (\$)'),
                // Add more text fields for other categories
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Save budget goals to database
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBudgetTextField(String category) {
    return TextFormField(
      decoration: InputDecoration(labelText: category),
      keyboardType: TextInputType.number,
      // You can add validation if needed
    );
  }
}
