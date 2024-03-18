import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Make sure this import points to where your ThemeProvider class is located.

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, String> _budgetGoals = {
    'Food': '',
    'Gas': '',
    'Housing & Utilities': '',
    'Entertainment': '',
    'Shopping': '',
    'Credit Cards': '',
  };

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
            title: Text('View Budget Goals'),
            onTap: () {
              _viewBudgetGoals(context);
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
              children: _budgetGoals.keys
                  .map((category) => _buildBudgetTextField(category))
                  .toList(),
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
                // Save budget goals to state
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _viewBudgetGoals(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Budget Goals'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _budgetGoals.entries
                  .map(
                    (entry) => ListTile(
                      title: Text('${entry.key}: \$${entry.value}'),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
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
      onChanged: (value) {
        setState(() {
          _budgetGoals[category] = value;
        });
      },
      // You can add validation if needed
    );
  }
}
