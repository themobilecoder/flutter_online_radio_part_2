import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  @override
  StationsState get initialState => StationsInitial();

  @override
  Stream<StationsState> mapEventToState(
    StationsEvent event,
  ) async* {}
}
