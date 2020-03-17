import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_radio/radio/radio_player.dart';
import 'package:online_radio/radio/radio_state.dart';
import 'package:online_radio/station.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final RadioPlayer radioPlayer;

  PlayerBloc({@required this.radioPlayer}) : assert(radioPlayer != null) {
    radioPlayer.radioStateStream.listen((radioState) {
      if (radioState == RadioState.PLAYING && state is PausedState) {
        this.add(PlayEvent((state as PausedState).currentStation));
      }
    });
  }

  @override
  PlayerState get initialState => StoppedState();

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    if (event is PlayEvent) {
      yield* _handlePlayEvent(event);
    } else if (event is PauseEvent) {
      yield* _handlePauseEvent(event);
    }
  }

  Stream<PlayerState> _handlePlayEvent(PlayEvent playEvent) async* {
    if (state is StoppedState) {
      _playNewRadioStation(playEvent);
      yield PlayingState(playEvent.station);
    } else if (state is PausedState) {
      if ((state as PausedState).currentStation != playEvent.station) {
        _playNewRadioStation(playEvent);
      } else {
        _playExistingRadioStation();
      }
      yield PlayingState(playEvent.station);
    } else if (state is PlayingState) {
      if ((state as PlayingState).currentStation != playEvent.station) {
        _playNewRadioStation(playEvent);
      } else {
        _playExistingRadioStation();
      }
      yield PlayingState(playEvent.station);
    }
  }

  Stream<PlayerState> _handlePauseEvent(PauseEvent pauseEvent) async* {
    if (state is PlayingState) {
      radioPlayer.pause();
      yield PausedState((state as PlayingState).currentStation);
    }
  }

  void _playExistingRadioStation() {
    radioPlayer.play();
  }

  void _playNewRadioStation(PlayEvent playEvent) {
    radioPlayer.setUrl(playEvent.station.radioUrl).then((_) {
      radioPlayer.play();
    });
  }
}
