part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

class PlayEvent extends PlayerEvent {
  final Station station;
  PlayEvent(this.station);
}

class PauseEvent extends PlayerEvent {}
