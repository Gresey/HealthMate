import 'package:flutter/material.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';



class DietPlan extends StatefulWidget {
  @override
  _DietPlanState createState() => _DietPlanState();
}

class _DietPlanState extends State<DietPlan> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  double? _weight;
  double? _height;
  int? _age;
  String? _gender;
  String? _activityLevel;
  String? _goal;
  String? isveg;

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      
        title: 'Diet Plan Generator',
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Weight Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.tryParse(value!);
                },
              ),
              const SizedBox(height: 16.0),

              // Height Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.tryParse(value!);
                },
              ),
              const SizedBox(height: 16.0),

              // Age Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.tryParse(value!);
                },
              ),
              const SizedBox(height: 16.0),
                 DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Are you a vegetarian?',
                  border: OutlineInputBorder(),
                ),
                items: ['Yes', 'No']
                    .map((mealpref) => DropdownMenuItem<String>(
                          value: mealpref,
                          child: Text(mealpref),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your meal preference';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    isveg = value;
                  });
                },
              ),
                  const SizedBox(height: 16.0),
              // Gender Input
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Activity Level Input
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extra Active']
                    .map((activity) => DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your activity level';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Goal Input
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  border: OutlineInputBorder(),
                ),
                items: ['Lose Weight', 'Gain Weight', 'Maintain Weight']
                    .map((goal) => DropdownMenuItem<String>(
                          value: goal,
                          child: Text(goal),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your goal';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _goal = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _generateDietPlan();
                  }
                },
                child: const Text('Generate Diet Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateDietPlan() {
    // Here you would use the collected data (_weight, _height, _age, _gender, _activityLevel, _goal)
    // to calculate the BMR, TDEE, and generate a diet plan. This is where you can integrate the GPT-3 API.
    
    print('Weight: $_weight kg');
    print('Height: $_height cm');
    print('Age: $_age years');
    print('Gender: $_gender');
    print('Activity Level: $_activityLevel');
    print('Goal: $_goal');

    // For now, just showing a simple dialog with the collected data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Diet Plan Details'),
          content: Text(
              'Weight: $_weight kg\nHeight: $_height cm\nAge: $_age\nGender: $_gender\nActivity Level: $_activityLevel\nGoal: $_goal'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
