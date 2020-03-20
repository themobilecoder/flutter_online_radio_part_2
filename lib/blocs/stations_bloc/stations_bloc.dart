import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_radio/repository/stations_repository.dart';
import 'package:online_radio/station.dart';

part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  final StationRepository stationRepository;
  final int _pageSize = 15;

  StationsBloc({@required this.stationRepository}) : assert(stationRepository != null);

  @override
  StationsState get initialState => LoadingStations();

  @override
  Stream<StationsState> mapEventToState(
    StationsEvent event,
  ) async* {
    if (event is FetchStations) {
      yield (LoadingStations());
      final List<Station> stations = await stationRepository.getStationsByCountryPaginated('au', 0, _pageSize);
      yield StationsFetchedState(stations: stations, stationPageIndex: 0, hasFetchedAll: false);
    } else if (event is FetchNextStations) {
      if (state is StationsFetchedState) {
        final currentState = (state as StationsFetchedState);
        final int index = currentState.stationPageIndex + _pageSize;
        final List<Station> oldStations = currentState.stations;
        yield FetchingNextStationsState();
        final List<Station> stations = await stationRepository.getStationsByCountryPaginated('au', index, _pageSize);
        yield StationsFetchedState(
            stations: oldStations..addAll(stations),
            stationPageIndex: index,
            hasFetchedAll: (stations.length < _pageSize) ? true : false);
      }
    }
  }
}
