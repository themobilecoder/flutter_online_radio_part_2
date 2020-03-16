part of 'player_bloc.dart';

@immutable
abstract class PlayerState {}

class StoppedState extends PlayerState {}

class PlayingState extends PlayerState {
  final Station currentStation;

  PlayingState(this.currentStation);
}

class PausedState extends PlayerState {
  final Station currentStation;

  PausedState(this.currentStation);
}
