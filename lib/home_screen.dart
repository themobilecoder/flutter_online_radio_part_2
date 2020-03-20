import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_radio/widgets/loading_indicator_with_message.dart';
import 'package:online_radio/widgets/media_player_sheet.dart';
import 'package:online_radio/widgets/radio_status_animation.dart';
import 'package:online_radio/widgets/station_list_item.dart';
import 'package:online_radio/widgets/title_header.dart';

import 'blocs/player_bloc/player_bloc.dart';
import 'blocs/stations_bloc/stations_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Radio'),
      ),
      body: BlocBuilder<StationsBloc, StationsState>(
        condition: (context, state) {
          return (state is! FetchingNextStationsState);
        },
        builder: (context, state) {
          if (state is InitialState) {
            context.bloc<StationsBloc>().add(FetchStations());
            return SizedBox();
          } else if (state is LoadingStationsState) {
            return LoadingIndicatorWithMessage(label: 'Fetching stations');
          } else if (state is StationsFetchedState) {
            final stations = state.stations;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleHeader(
                  title: 'Top Stations',
                  status: BlocBuilder<PlayerBloc, PlayerState>(builder: (context, state) {
                    if (state is PausedState || state is StoppedState) {
                      return PausedStatus();
                    } else {
                      return PlayingStatus();
                    }
                  }),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (state is StationsFetchedState &&
                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        context.bloc<StationsBloc>().add(FetchNextStations());
                        return true;
                      } else {
                        return false;
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (index < stations.length) {
                          return StationListItem(
                            name: stations[index].name,
                            imageUrl: stations[index].imageUrl,
                            onTap: () {
                              context.bloc<PlayerBloc>().add(PlayEvent(stations[index]));
                            },
                          );
                        } else if (index == stations.length && !state.hasFetchedAll) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                BlocBuilder<PlayerBloc, PlayerState>(
                  builder: (context, state) {
                    if (state is! StoppedState) {
                      return SizedBox(height: 80);
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('An error has occurred'),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      context.bloc<StationsBloc>().add(FetchStations());
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).accentColor,
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }
        },
      ),
      bottomSheet: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is StoppedState) {
            return SizedBox();
          } else if (state is PlayingState) {
            final currentStation = state.currentStation;
            return MediaPlayerSheet(
              title: currentStation.name,
              imageUrl: currentStation.imageUrl,
              mediaButtonIcon: Icon(
                Icons.pause,
                size: 32,
              ),
              onMediaButtonPress: () {
                context.bloc<PlayerBloc>().add(PauseEvent());
              },
            );
          } else {
            final currentStation = (state as PausedState).currentStation;
            return MediaPlayerSheet(
              title: currentStation.name,
              imageUrl: currentStation.imageUrl,
              mediaButtonIcon: Icon(
                Icons.play_arrow,
                size: 32,
              ),
              onMediaButtonPress: () {
                context.bloc<PlayerBloc>().add(PlayEvent(currentStation));
              },
            );
          }
        },
      ),
    );
  }
}
