import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_radio/blocs/player_bloc/player_bloc.dart';
import 'package:online_radio/blocs/stations_bloc/stations_bloc.dart';
import 'package:online_radio/home_screen.dart';
import 'package:online_radio/radio/just_audio_player.dart';
import 'package:online_radio/radio/radio_player.dart';
import 'package:online_radio/repository/radio_browser_stations_repository.dart';
import 'package:online_radio/repository/stations_repository.dart';

class RadioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RadioPlayer radioPlayer = JustAudioPlayer();
    final StationRepository stationRepository = RadioBrowserRepository(Dio());
    return MaterialApp(
      title: 'Online Radio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PlayerBloc>(
            create: (context) => PlayerBloc(radioPlayer: radioPlayer),
          ),
          BlocProvider<StationsBloc>(
            create: (context) => StationsBloc(stationRepository: stationRepository),
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
