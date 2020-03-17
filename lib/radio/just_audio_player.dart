import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:online_radio/radio/radio_player.dart';
import 'package:online_radio/radio/radio_state.dart';

class JustAudioPlayer extends RadioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Stream<RadioState> radioStateStream;

  JustAudioPlayer() {
    radioStateStream = _audioPlayer.playbackStateStream.map(_mapToRadioState);
  }

  @override
  Future<void> setUrl(String url) async {
    return _audioPlayer.setUrl(url);
  }

  @override
  Future<void> play({@required String url}) async {
    return _audioPlayer.play();
  }

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  RadioState _mapToRadioState(AudioPlaybackState audioState) {
    switch (audioState) {
      case AudioPlaybackState.none:
      case AudioPlaybackState.stopped:
        return RadioState.STOPPED;
      case AudioPlaybackState.paused:
        return RadioState.PAUSED;
      case AudioPlaybackState.playing:
        return RadioState.PLAYING;
      default:
        return RadioState.UNKNOWN;
    }
  }
}
