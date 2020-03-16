import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:online_radio/radio/radio_player.dart';

class JustAudioPlayer extends RadioPlayer {
  final audioPlayer = AudioPlayer();

  @override
  Future<void> setUrl(String url) async {
    return audioPlayer.setUrl(url);
  }

  @override
  Future<void> play({@required String url}) async {
    return audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return audioPlayer.pause();
  }
}
