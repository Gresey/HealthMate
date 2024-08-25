part of 'dashboard_bloc.dart';

// Abstract base class for all states
@immutable
sealed class DashboardState {}

// Initial state when the dashboard is first loaded
final class DashboardInitial extends DashboardState {}

// State to handle fetched user details and calorie burnt data
final class UpdateDashboardWithValuesState extends DashboardState {
  final Map<String, dynamic> userData;
  final List<CalorieBurntData> calorieburnt;

  UpdateDashboardWithValuesState({
    required this.userData,
    required this.calorieburnt,
  });
}

// State to handle errors
final class DashboardErrorState extends DashboardState {
  final String message;

  DashboardErrorState(this.message);
}