part of 'stations_bloc.dart';

@immutable
abstract class StationsEvent {}

class FetchStations extends StationsEvent {}

class FetchNextStations extends StationsEvent {}
