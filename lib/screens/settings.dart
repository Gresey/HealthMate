// @dart=2.17
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _waterReminders = true;

  void _toggleWaterReminders(bool value) {
    setState(() {
      _waterReminders = value;
    });
  }

 void _contactUs() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController _queryController = TextEditingController();

      return AlertDialog(
        title: Text('Contact Us'),
        content: TextField(
          controller: _queryController,
          decoration: InputDecoration(
            hintText: 'Enter your query',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Implement your send logic here
              print('Query: ${_queryController.text}');
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Send'),
          ),
        ],
      );
    },
  );
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Water Reminders'),
              value: _waterReminders,
              onChanged: _toggleWaterReminders,
            ),
            ListTile(
              title: Text('Contact Us'),
              onTap: _contactUs,
            ),
            
          ],
        ),
      ),
    );
  }
}