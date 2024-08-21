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
    // Implement your contact us logic here
    print('Contact us clicked');
  }

  void _viewPrivacyPolicy() {
    // Implement your privacy policy logic here
    print('Privacy policy clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
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
            ListTile(
              title: Text('Privacy Policy'),
              onTap: _viewPrivacyPolicy,
            ),
          ],
        ),
      ),
    );
  }
}