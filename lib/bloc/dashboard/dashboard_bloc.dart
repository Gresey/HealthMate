import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../widgets/calorieburnt.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardFetchValuesEvent>(fetchDashboardValues);
  }

  Future<void> fetchDashboardValues(
      DashboardFetchValuesEvent event, Emitter<DashboardState> emit) async {
    final token = await AuthService().getToken();

    if (token == null) {
      emit(DashboardErrorState('User is not authenticated'));
      return;
    }

    try {
      final userDetailsResponse = await http.get(
        Uri.parse('http://localhost:4000/getroutes/getuserdetails'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (userDetailsResponse.statusCode == 200) {
        final responseBody = jsonDecode(userDetailsResponse.body) as Map<String, dynamic>;

        final username = (responseBody['username'] as String).split(' ').first;
        final stepsCount = responseBody['stepsCount'] as int? ?? 0;
        final calorieBurn = (responseBody['calorieBurn'] as num?)?.toDouble() ?? 0.0;
        final waterIntake = (responseBody['waterIntake'] as num?)?.toDouble() ?? 0.0;
        final sleepHours = responseBody['sleep'] as int? ?? 0;
        final calorieConsumed = (responseBody['calorieconsumed'] as num?)?.toDouble() ?? 0.0;

        // Fetch calorie burnt data
        final calorieBurntResponse = await http.get(
          Uri.parse('http://localhost:4000/getroutes/getcalorieburnt'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        List<CalorieBurntData> calorieburnt = [];
        if (calorieBurntResponse.statusCode == 200) {
          final calorieBurntResponseBody = jsonDecode(calorieBurntResponse.body) as Map<String, dynamic>;
          final data = calorieBurntResponseBody['data'] as Map<String, dynamic>;

          calorieburnt = data.entries.map((entry) {
            return CalorieBurntData(entry.key, entry.value);
          }).toList();
        } else {
          throw Exception('Failed to load calorie burnt data');
        }

        emit(UpdateDashboardWithValuesState(
          userData: {
            'username': username,
            'stepsCount': stepsCount,
            'calorieBurn': calorieBurn,
            'waterIntake': waterIntake,
            'sleepHours': sleepHours,
            'calorieConsumed': calorieConsumed,
          },
          calorieburnt: calorieburnt,
        ));
      } else {
        emit(DashboardErrorState('Failed to fetch user details'));
      }
    } catch (e) {
      emit(DashboardErrorState('Error: $e'));
    }
  }
}
