part of 'workout_bloc.dart';

@immutable
abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoadingState extends WorkoutState {}

class FetchWorkoutDetailsState extends WorkoutState {
  final double totalCalories;
  final List<Map<String, Object>> fetchedActivities;

  FetchWorkoutDetailsState({
    required this.totalCalories,
    required this.fetchedActivities,
  });
}

class WorkoutErrorState extends WorkoutState {
  final String message;

  WorkoutErrorState(this.message);
}
