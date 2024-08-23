
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc() : super(WorkoutInitial()) {
    on<FetchWorkoutDetailsEvent>(fetchworkoutdetailsevent);
    on<AddWorkoutActivityEvent>(addWorkoutActivityEvent); 
    on<SaveWorkoutDetailsEvent>(saveWorkoutDetailsEvent);
  }

  Future<void> fetchworkoutdetailsevent(
      FetchWorkoutDetailsEvent event, Emitter<WorkoutState> emit) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      emit(WorkoutErrorState("User is not authenticated"));
      return;
    }
    try {
      final uri =
          Uri.parse('http://localhost:4000/getroutes/getworkoutdetails');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, Object>> fetchedActivities = data.map((json) {
          return {
            'title': json['NameofWorkout'] as String? ?? 'Unknown',
            'time': (json['timeofworkout'] as num?)?.toInt() ?? 0,
            'calorieburnt': (json['calorieburnt'] as num?)?.toDouble() ?? 0.0,
            'MET': (json['MET'] as num?)?.toDouble() ?? 0.0,
          };
        }).toList();

        double totalcalories = fetchedActivities.fold(
          0.0,
          (sum, activity) => sum + (activity['calorieburnt'] as double),
        );
        emit(FetchWorkoutDetailsState(
            totalCalories: totalcalories,
            fetchedActivities: fetchedActivities));
      } else {
        emit(WorkoutErrorState(
            "Failed to fetch Workout data. Status code: ${response.statusCode}"));
      }
    } catch (e) {
      emit(WorkoutErrorState('Error: $e'));
    }
  }

  // Event handler for adding a new workout activity
  Future<void> addWorkoutActivityEvent(
      AddWorkoutActivityEvent event, Emitter<WorkoutState> emit) async {
    if (state is FetchWorkoutDetailsState) {
      final currentState = state as FetchWorkoutDetailsState;
      final updatedActivities = List<Map<String, Object>>.from(currentState.fetchedActivities)
        ..add(event.newActivity);

      double totalcalories = updatedActivities.fold(
        0.0,
        (sum, activity) => sum + (activity['calorieburnt'] as double),
      );

      emit(FetchWorkoutDetailsState(
          totalCalories: totalcalories,
          fetchedActivities: updatedActivities));
    }
  }

  Future<void> saveWorkoutDetailsEvent(
      SaveWorkoutDetailsEvent event, Emitter<WorkoutState> emit) async {
    try {
      await addWorkoutDetails(event.activities, event.totalCalories);
      emit(FetchWorkoutDetailsState(
          totalCalories: event.totalCalories,
          fetchedActivities: event.activities));
    } catch (e) {
      emit(WorkoutErrorState('Failed to save workout details: $e'));
    }
  }

  Future<void> addWorkoutDetails(List<Map<String, Object>> activities, double totalCalories) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final List<Map<String, Object>> simplifiedWorkouts = activities.map((activity) {
        return {
          'title': activity['title'] as String,
          'time': activity['time'] as int,
          'calorieburnt': activity['calorieburnt'] as double,
        };
      }).toList();

      final jsondata = jsonEncode({
        'activities': simplifiedWorkouts,
        'totalCalories': totalCalories.toStringAsFixed(0),
      });

      final uri =
          Uri.parse("http://localhost:4000/postroutes/saveworkoutdetails");
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsondata,
      );

      if (response.statusCode == 200) {
        print("Workout Data saved successfully");
        print('Response: ${response.body}');
      } else {
        print(
            'Failed to send Workout data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
