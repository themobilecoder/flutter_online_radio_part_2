import 'package:online_radio/radio/radio_state.dart';

abstract class RadioPlayer {
  Stream<RadioState> radioStateStream;

  Future<void> setUrl(String url);
  Future<void> play();
  Future<void> pause();
}
