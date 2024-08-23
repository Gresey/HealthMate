part of 'dashboard_bloc.dart';

// Abstract base class for all events
@immutable
sealed class DashboardEvent {}

// Event to fetch user details and calorie burnt data
final class DashboardFetchValuesEvent extends DashboardEvent {}
