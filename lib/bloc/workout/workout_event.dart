part of 'workout_bloc.dart';

@immutable
abstract class WorkoutEvent {}

class FetchWorkoutDetailsEvent extends WorkoutEvent {}

class AddWorkoutActivityEvent extends WorkoutEvent {
  final Map<String, Object> newActivity;

  AddWorkoutActivityEvent(this.newActivity);
}

class SaveWorkoutDetailsEvent extends WorkoutEvent {
  final List<Map<String, Object>> activities;
  final double totalCalories;

  SaveWorkoutDetailsEvent(this.activities, this.totalCalories);
}
