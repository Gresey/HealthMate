import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heathmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:heathmate/screens/diet.dart';
import 'package:heathmate/screens/map_page.dart';
import 'package:heathmate/screens/sleep.dart';
import 'package:heathmate/screens/steps.dart';
import 'package:heathmate/screens/water.dart';
import 'package:heathmate/screens/workout.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/calorieburnt.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = DashboardBloc()..add(DashboardFetchValuesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _dashboardBloc,
      child: Commonscaffold(
          title: 'HealthMate',
        
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UpdateDashboardWithValuesState) {
              final userData = state.userData;
              final calorieburnt = state.calorieburnt;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    _buildWelcomeMessage(userData['username'] as String),
                    const SizedBox(height: 14.0),
                    CalorieBurntScreen(calorieburnt: calorieburnt),
                    const SizedBox(height: 18.0),
                    _buildFeatureCards(userData),
                  ],
                ),
              );
            } else if (state is DashboardErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown State'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(String username) {
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
            style: const TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Keep pushing forward!',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
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

  Widget _buildFeatureCards(Map<String, dynamic> userData) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildCard(
                title: "Map",
                description: "Find Nearby Gyms, Hospitals, and Medical Stores",
                icon: Icons.map,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapPage()));
                },
              ),
            ),
            
          ],
        ),
        Row(
          children: <Widget>[
            // Expanded(
            //   child: _buildCard(
            //     title: "Steps",
            //     description: "Steps Count: ${userData['stepsCount']}",
            //     icon: Icons.legend_toggle_sharp,
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const Steps()));
            //     },
            //   ),
            // ),
            Expanded(
              child: _buildCard(
                title: "Water",
                description: "Water Intake: ${userData['waterIntake']} glasses",
                icon: Icons.water_rounded,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WaterGlass()));
                },
              ),
            ),
            Expanded(
              child: _buildCard(
                title: "Workout",
                description: "Calories Burnt: ${userData['calorieBurn']}",
                icon: Icons.man,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Workout()),
                  );
                  _dashboardBloc.add(DashboardFetchValuesEvent());
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
                description: "Calories Consumed: ${userData['calorieConsumed']}",
                icon: Icons.food_bank,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Diet()));
                },
              ),
            ),
            Expanded(
              child: _buildCard(
                title: "Sleep",
                description: "Sleep Stats: ${userData['sleepHours']}",
                icon: Icons.nightlight_round,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SleepPage()));
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
              side: const BorderSide(
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