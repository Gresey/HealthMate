// @dart=2.17
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:heathmate/services/auth_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:heathmate/widgets/CommonScaffold.dart';

import '../bloc/workout/workout_bloc.dart';

class Workout extends StatefulWidget {
  const Workout({super.key});

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<Workout> {
 final TextEditingController _workoutController = TextEditingController();
  String _workoutTitle = "Workout";
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  String? _selectedExercise;
  double _selectedExerciseMET = 0.0;
  double _weight = 50.0;
  double totalCalories = 0.0;
  late WorkoutBloc workoutBloc;

  final List<Map<String, Object>> exercises = [
    {"name": "Bench Press", "value": 6.0},
    {"name": "Incline Dumbbell Press", "value": 6.5},
    {"name": "Bar Dips", "value": 7.0},
    {"name": "Standing Cable Chest Fly", "value": 6.0},
    {"name": "Overhead Press", "value": 6.0},
    {"name": "Seated Dumbbell Shoulder Press", "value": 6.5},
    {"name": "Dumbbell Lateral Raise", "value": 5.5},
    {"name": "Reverse Dumbbell Fly", "value": 5.5},
    {"name": "Deadlift", "value": 6.5},
    {"name": "Lat Pulldown", "value": 5.5},
    {"name": "Pull-Up", "value": 7.0},
    {"name": "Barbell Row", "value": 6.0},
    {"name": "Dumbbell Row", "value": 6.0},
    {"name": "Barbell Curl", "value": 5.5},
    {"name": "Dumbbell Curl", "value": 5.5},
    {"name": "Hammer Curl", "value": 5.5},
    {"name": "Barbell Lying Triceps Extension", "value": 6.0},
    {"name": "Overhead Cable Triceps Extension", "value": 6.0},
    {"name": "Tricep Pushdown", "value": 6.0},
    {"name": "Close-Grip Bench Press", "value": 6.5},
    {"name": "Squat", "value": 6.0},
    {"name": "Hack Squats", "value": 6.0},
    {"name": "Leg Extension", "value": 5.5},
    {"name": "Bulgarian Split Squat", "value": 6.0},
    {"name": "Seated Leg Curl", "value": 5.5},
    {"name": "Lying Leg Curl", "value": 5.5},
    {"name": "Romanian Deadlift", "value": 6.0},
    {"name": "Hip Thrust", "value": 6.0},
    {"name": "Cable Crunch", "value": 5.5},
    {"name": "Hanging Leg Raise", "value": 6.0},
    {"name": "High to Low Wood Chop", "value": 6.0},
    {"name": "Crunch", "value": 5.5},
    {"name": "Standing Calf Raise", "value": 5.5},
    {"name": "Seated Calf Raise", "value": 5.5},
    {"name": "Jump Rope", "value": 12.0},
    {"name": "Running (6 mph)", "value": 9.8},
    {"name": "Jogging (5 mph)", "value": 7.0},
    {"name": "Walking (4 mph)", "value": 3.8},
    {"name": "Cycling (12-14 mph)", "value": 8.0},
    {"name": "Swimming (general)", "value": 7.0},
    {"name": "Rowing Machine (moderate)", "value": 7.0},
    {"name": "Hiking (moderate)", "value": 6.0},
    {"name": "Climbing (moderate)", "value": 9.0},
    {"name": "Elliptical Trainer (moderate)", "value": 5.5},
    {"name": "Jumping Jacks", "value": 8.0},
    {"name": "High-Intensity Interval Training (HIIT)", "value": 12.0},
    {"name": "Stair Climbing", "value": 8.0},
    {"name": "Dancing (social)", "value": 5.5},
    {"name": "Yoga", "value": 2.5},
    {"name": "Pilates", "value": 3.0},
  ];



  @override
  void initState() {
    super.initState();

    // Initialize the WorkoutBloc
    workoutBloc = WorkoutBloc();

    // Fetch initial workout details
    workoutBloc.add(FetchWorkoutDetailsEvent());

    // Add listener for when the WorkoutBloc's state changes
    workoutBloc.stream.listen((state) {
      if (state is FetchWorkoutDetailsState) {
        // Check if the workout activities have been updated
        final activities = state.fetchedActivities;
        if (activities.isNotEmpty) {
          setState(() {
            totalCalories = state.totalCalories;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    workoutBloc.close(); // Close the bloc when disposing
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      if (_seconds != 0) {
        final calorieburnt = calculateCaloriesBurnt(_seconds, _selectedExerciseMET);
        final newActivity = {
          'title': _workoutTitle,
          'time': _seconds,
          'MET': _selectedExerciseMET,
          'calorieburnt': calorieburnt,
        };

        final updatedActivities = List<Map<String, Object>>.from(
            (workoutBloc.state as FetchWorkoutDetailsState).fetchedActivities);

        final existingIndex = updatedActivities.indexWhere(
          (activity) => activity['title'] == _workoutTitle,
        );

        if (existingIndex >= 0) {
          updatedActivities[existingIndex] = newActivity;
        } else {
          updatedActivities.add(newActivity);
        }

        totalCalories = updatedActivities.fold(
          0.0,
          (sum, activity) => sum + (activity['calorieburnt'] as double),
        );

        workoutBloc.add(SaveWorkoutDetailsEvent(updatedActivities, totalCalories));
      }
      _seconds = 0;
      _isRunning = false;
      _isPaused = false;
    });
  }

  double calculateCaloriesBurnt(int seconds, double metValue) {
    final hours = seconds / 3600;
    return metValue * _weight * hours;
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      title: "Workout",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _selectedExercise,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedExercise = newValue;
                  final selectedExerciseMap = exercises
                      .firstWhere((exercise) => exercise['name'] == newValue);
                  _selectedExerciseMET = selectedExerciseMap['value'] as double;
                  _workoutTitle = newValue ?? 'Workout';
                });
              },
              items: exercises.map<DropdownMenuItem<String>>((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise['name'] as String?,
                  child: Text(exercise['name'] as String),
                );
              }).toList(),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Select Exercise',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Timer: ${_formatTime(_seconds)}',
              style: const TextStyle(fontSize: 18.0), // Increase the font size
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning || _isPaused ? _stopTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,foregroundColor: Colors.white
                  ),
                  child: Text(_isRunning ? 'Stop' : 'Start'),
                ),
                if (_isRunning || _isPaused)
                  ElevatedButton(
                    onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,foregroundColor: Colors.white
                    ),
                    child: Text(_isPaused ? 'Resume' : 'Pause'),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            if (totalCalories > 0)
              Text(
                'Total Calories Burned: ${totalCalories.toStringAsFixed(2)} kcal',
                style: const TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            const SizedBox(height: 20.0),
            BlocConsumer<WorkoutBloc, WorkoutState>(
              bloc: workoutBloc,
              builder: (context, state) {
                if (state is WorkoutInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FetchWorkoutDetailsState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.fetchedActivities.length,
                      itemBuilder: (context, index) {
                        final activity = state.fetchedActivities[index];
                        return Card(
                          color: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0, // Remove shadow
                          child: ListTile(
                            title: Text(
                              activity['title'] as String,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Time: ${_formatTime(activity['time'] as int)} | Calories: ${(activity['calorieburnt'] as double).toStringAsFixed(2)} kcal',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is WorkoutErrorState) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('Unknown State'));
                }
              },
              listener: (context, state) {
                if (state is FetchWorkoutDetailsState) {
                  print("Workout activities updated: ${state.fetchedActivities.length}");
                } else if (state is WorkoutErrorState) {
                  // Handle error state if needed
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
