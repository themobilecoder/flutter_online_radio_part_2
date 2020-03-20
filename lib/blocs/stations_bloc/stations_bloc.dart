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
  final String _countryCode = 'au';

  StationsBloc({@required this.stationRepository}) : assert(stationRepository != null);

  @override
  StationsState get initialState => InitialState();

  @override
  Stream<StationsState> mapEventToState(
    StationsEvent event,
  ) async* {
    if (event is FetchStations) {
      yield (LoadingStationsState());
      try {
        final List<Station> stations =
            await stationRepository.getStationsByCountryPaginated(_countryCode, 0, _pageSize);
        yield StationsFetchedState(
          stations: stations,
          stationPageIndex: 0,
          hasFetchedAll: false,
        );
      } catch (err) {
        yield StationsFetchErrorState();
      }
    } else if (event is FetchNextStations && state is StationsFetchedState) {
      final currentState = (state as StationsFetchedState);
      final int index = currentState.stationPageIndex + _pageSize;
      final List<Station> oldStations = currentState.stations;
      yield FetchingNextStationsState();
      try {
        final List<Station> stations =
            await stationRepository.getStationsByCountryPaginated(_countryCode, index, _pageSize);
        yield StationsFetchedState(
          stations: oldStations..addAll(stations),
          stationPageIndex: index,
          hasFetchedAll: (stations.length < _pageSize) ? true : false,
        );
      } catch (err) {
        yield StationsFetchErrorState();
      }
    }
  }
}
