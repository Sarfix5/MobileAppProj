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
            title: Text('Manage Categories'),
            onTap: () {
              // Navigate to category management screen
            },
          ),
          ListTile(
            title: Text('Set Budget Goals'),
            onTap: () {
              // Navigate to budget goal setting screen
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
