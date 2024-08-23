import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pedometer/pedometer.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/stepschart.dart';
import 'package:heathmate/services/auth_service.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int _stepsGoal = 10000; // Example goal
  int _steps = 0;
  StreamSubscription<StepCount>? _subscription;
  List<StepsData> chartData = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      onDone: _onStepCountDone,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
      // Update chart data or any other state updates
    });
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void _onStepCountDone() {
    print('Step Count Stream closed');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(

      
        title: 'Steps Tracker',
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Steps Taken:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_steps',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Goal: $_stepsGoal steps',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            StepsChart(chartData: chartData), // Assuming you have a StepsChart widget
          ],
        ),
      ),
    );
  }
}