// @dart=2.17
import 'package:flutter/material.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       appBar: AppBar(title: const Text("About"),),
      
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            SizedBox(height: 10),
            Text(
              'HealthMate is a fitness tracking application that monitors and visualizes key health metrics such as water intake, sleep, workout time, diet, calories burned, and calories consumed. Users can view their data through weekly graphs, helping them to track progress and adjust their health routines accordingly. The app leverages Flutter and Dart for cross-platform development, BLoC for state management, and uses a backend built with Node.js, MongoDB, and Express to handle data through RESTful APIs.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Weekly graphs for tracking water intake, sleep, workout duration, diet, and calories\n'
              '- Real-time monitoring of fitness and health metrics\n'
              '- Data visualization for easier tracking and analysis\n'
              '- Cross-platform support with Flutter and Dart\n'
              '- Efficient state management using BLoC\n',

              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          
           
          ],
        ),
      ),
    );
  }
}