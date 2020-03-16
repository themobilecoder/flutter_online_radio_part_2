import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:online_radio/station.dart';
import 'package:online_radio/widgets/station_list_item.dart';

import 'blocs/player_bloc/player_bloc.dart';
import 'widgets/idle_dots.dart';

class HomeScreen extends StatelessWidget {
  final _planetRockUrl = 'https://stream-mz.planetradio.co.uk/planetrock.mp3';
  final _planetRockImage = 'assets/images/planet_rock.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Radio'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Top Stations',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<PlayerBloc, PlayerState>(builder: (context, state) {
                    if (state is PausedState || state is StoppedState) {
                      return IdleDots(
                        color: Theme.of(context).accentColor,
                      );
                    } else {
                      return Loading(
                        indicator: LineScalePulseOutIndicator(),
                        size: 30,
                        color: Theme.of(context).accentColor,
                      );
                    }
                  })
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return StationListItem(
                      name: 'Planet Rock',
                      stationImage: Image.asset(_planetRockImage),
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).primaryColor,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                width: 50,
                child: Image.asset(_planetRockImage),
              ),
            ),
            Text(
              'Planet Rock',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  if (state is PausedState || state is StoppedState) {
                    return IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        size: 32,
                      ),
                      onPressed: () {
                        context.bloc<PlayerBloc>().add(PlayEvent(Station(_planetRockUrl, '', 'Planet Rock')));
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(
                        Icons.pause,
                        size: 32,
                      ),
                      onPressed: () {
                        context.bloc<PlayerBloc>().add(PauseEvent());
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
