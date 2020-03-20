part of 'stations_bloc.dart';

@immutable
abstract class StationsState {
  const StationsState();
}

class InitialState extends StationsState {}

class LoadingStationsState extends StationsState {}

class FetchingNextStationsState extends StationsState {}

class StationsFetchedState extends StationsState {
  final List<Station> stations;
  final int stationPageIndex;
  final bool hasFetchedAll;

  const StationsFetchedState({
    @required this.stations,
    @required this.stationPageIndex,
    @required this.hasFetchedAll,
  }) : assert(stations != null && stationPageIndex != null && hasFetchedAll != null);
}

class StationsFetchErrorState extends StationsState {}
