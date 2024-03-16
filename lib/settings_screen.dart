import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Make sure this import points to where your ThemeProvider class is located.

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // This uses the primary color of the current theme, whether it's light or dark.
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Set Budget Goals'),
            onTap: () {
              _showBudgetDialog(context);
            },
          ),
          ListTile(
            title: Text('Toggle Theme'),
            trailing: Switch(
              value: themeProvider.getTheme() == ThemeData.dark(),
              onChanged: (value) {
                themeProvider.setTheme(
                  value ? ThemeData.dark() : ThemeData.light(),
                );
              },
            ),
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
                // Save budget goals to database or shared preferences
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
