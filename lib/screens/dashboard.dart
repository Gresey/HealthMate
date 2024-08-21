// @dart=2.17

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heathmate/screens/diet.dart';
import 'package:heathmate/screens/map_page.dart';
import 'package:heathmate/screens/sleep.dart';
import 'package:heathmate/screens/steps.dart';
import 'package:heathmate/screens/water.dart';
import 'package:heathmate/screens/workout.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/calorieburnt.dart';
import 'package:heathmate/widgets/stepschart.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<CalorieBurntData> calorieburnt = [];
  String username = "User"; // Default username
  int stepsCount = 2133; // Default values for demonstration
  double calorieBurn = 500.0;
  double waterIntake = 2.5;
  int sleepHours = 7;

  @override
  void initState() {
    super.initState();
    getCalorieBurnt();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final token = await AuthService().getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://yourapiurl.com/getusername'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          username = responseBody['username'];
        });
      } else {
        print('Failed to fetch username: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getCalorieBurnt() async {
    final token = await AuthService().getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.112:4000/getroutes/getcalorieburnt'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final Map<String, dynamic> data = responseBody['data'];

        List<CalorieBurntData> tempCalorieBurnt = data.entries.map((entry) {
          return CalorieBurntData(entry.key, entry.value);
        }).toList();
       
        setState(() {
          calorieburnt = tempCalorieBurnt;
        });
      } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            _buildWelcomeMessage(),
            const SizedBox(height: 14.0),
            CalorieBurntScreen(calorieburnt: calorieburnt),
            const SizedBox(height: 18.0),
          
            
            _buildFeatureCards(),
          ],
        ),
      ),
    );
  }

 Widget _buildWelcomeMessage() {
  return Container(
    margin: const EdgeInsets.all(20.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.deepPurple),
      
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Hello, $username',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Keep pushing forward! 💪',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          '"Success is not final, failure is not fatal: It is the courage to continue that counts."',
          style: TextStyle(
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
            color: Colors.deepPurple,
          ),
        ),
      ],
    ),
  );
}

 
  Widget _buildFeatureCards() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              
            child: _buildCard(
                title: "Map",
                description: "Find Nearby Gyms, Hospitals and Medical Stores",
                icon: Icons.map,
               // color: Colors.deepPurpleAccent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
                },
              ),
            ),
             Expanded(
              child: _buildCard(
                title: "Water",
                description: "Water Intake: $waterIntake L",
                icon: Icons.water_rounded,
               // color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WaterGlass()));
                },
              ),
            ),
          
          ],
        ),
        Row(
          children: <Widget>[
             Expanded(
              child: _buildCard(
                title: "Steps",
                description: "Steps Count: $stepsCount",
                icon: Icons.legend_toggle_sharp,
               // color: Colors.purple.shade400,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Steps()));
                },
              ),
            ),
              Expanded(
              child: _buildCard(
                title: "Workout",
                description: "Calories Burnt",
                icon: Icons.man,
              //  color: const Color.fromARGB(255, 149, 125, 245),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Workout()),
                  );
                  getCalorieBurnt();
                },
              ),
            ),
          
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildCard(
                title: "Diet",
                description: "Calories Consumed",
                icon: Icons.food_bank,
              //  color: Colors.deepPurple.shade300,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Diet()));
                },
              ),
            ),
              Expanded(
              child: _buildCard(
                title: "Sleep",
                description: "Sleep Stats",
                icon: Icons.nightlight_round,
              //  color: const Color.fromARGB(255, 234, 172, 141),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SleepPage()));
                },
              ),
            ),
          ],
        ),
    
      ],
    );
  }
Widget _buildCard({
  required String title,
  required String description,
  required IconData icon,
  required Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(7.0),
      child: SizedBox(
        height: 150,
        width: 100,
        child: Card(
      
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.deepPurple, // Set border color
              width: 2.0, // Border width
            ),
          ),
          margin: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              
                color: Colors.deepPurple,
              
              
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(icon, size: 40.0, color: Colors.white),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


}
