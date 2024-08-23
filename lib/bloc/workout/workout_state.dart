part of 'workout_bloc.dart';

@immutable
abstract class WorkoutState {}

// Initial state when the workout feature is first loaded
class WorkoutInitial extends WorkoutState {}

// State for when workout details are being fetched
class WorkoutLoadingState extends WorkoutState {}

// State for when workout details have been successfully fetched
class FetchWorkoutDetailsState extends WorkoutState {
  final double totalCalories;
  final List<Map<String, Object>> fetchedActivities;

  FetchWorkoutDetailsState({
    required this.totalCalories,
    required this.fetchedActivities,
  });
}

// State for when there is an error fetching or saving workout details
class WorkoutErrorState extends WorkoutState {
  final String message;

  WorkoutErrorState(this.message);
}
