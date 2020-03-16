part of 'stations_bloc.dart';

@immutable
abstract class StationsState {}

class StationsInitial extends StationsState {}

class FetchLoadingState extends StationsState {}

class StationsFetchedState extends StationsState {}

class StationsFetchErrorState extends StationsState {}
