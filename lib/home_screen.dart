import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_radio/widgets/station_list_item.dart';

import 'player_bloc/player_bloc.dart';

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
              child: Text(
                'Top Stations',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
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
                  if (state is PausedState) {
                    return IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        size: 32,
                      ),
                      onPressed: () {
                        context.bloc<PlayerBloc>().add(PlayEvent(url: _planetRockUrl));
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
