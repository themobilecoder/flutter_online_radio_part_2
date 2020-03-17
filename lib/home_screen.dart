import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:online_radio/widgets/loading_indicator_with_message.dart';
import 'package:online_radio/widgets/media_player_sheet.dart';
import 'package:online_radio/widgets/station_list_item.dart';
import 'package:online_radio/widgets/title_header.dart';

import 'blocs/player_bloc/player_bloc.dart';
import 'blocs/stations_bloc/stations_bloc.dart';
import 'widgets/idle_dots.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Radio'),
      ),
      body: BlocBuilder<StationsBloc, StationsState>(
        condition: (context, state) {
          if (state is FetchingNextStationsState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state is LoadingStations) {
            context.bloc<StationsBloc>().add(FetchStations());
            return LoadingIndicatorWithMessage(
              label: 'Fetching stations',
            );
          } else if (state is StationsFetchedState) {
            final stations = state.stations;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleHeader(
                  title: 'Top Stations',
                  status: BlocBuilder<PlayerBloc, PlayerState>(builder: (context, state) {
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
                            stationImage: CachedNetworkImage(
                              imageUrl: stations[index].imageUrl,
                              placeholder: (context, _) {
                                return SvgPicture.asset(
                                  'assets/images/music.svg',
                                  semanticsLabel: 'Music',
                                  color: Theme.of(context).textTheme.body1.color,
                                );
                              },
                              errorWidget: (context, _, __) {
                                return SvgPicture.asset(
                                  'assets/images/music.svg',
                                  semanticsLabel: 'Music',
                                  color: Theme.of(context).textTheme.body1.color,
                                );
                              },
                            ),
                            onTap: () {
                              context.bloc<PlayerBloc>().add(PlayEvent(stations[index]));
                            },
                          );
                        } else if (index == stations.length && !state.hasFetchedAll) {
                          return Center(
                            child: CircularProgressIndicator(),
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
                      return SizedBox(
                        height: 80,
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ],
            );
          } else {
            return Center(
              child: Text('Error Fetching Statons'),
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
