import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:online_radio/widgets/station_list_item.dart';

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
      body: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: BlocBuilder<StationsBloc, StationsState>(
            builder: (context, state) {
              if (state is LoadingStations) {
                context.bloc<StationsBloc>().add(FetchStations());
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Fetching Stations'),
                    ],
                  ),
                );
              } else if (state is StationsFetchedState) {
                final stations = (context.bloc<StationsBloc>().state as StationsFetchedState).stations;
                return Column(
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
                          itemCount: stations.length,
                          itemBuilder: (context, index) {
                            return StationListItem(
                              name: stations[index].name,
                              stationImage: Image.network(stations[index].imageUrl),
                              onTap: () {
                                context.bloc<PlayerBloc>().add(PlayEvent(stations[index]));
                              },
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text('Error Fetching Statons'),
                );
              }
            },
          )),
      bottomSheet: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is StoppedState) {
            return Container(
              color: Theme.of(context).primaryColor,
              height: 100,
            );
          } else if (state is PlayingState) {
            final currentStation = state.currentStation;
            return Container(
              height: 100,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Image.network(currentStation.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        currentStation.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.pause,
                            size: 32,
                          ),
                          onPressed: () {
                            context.bloc<PlayerBloc>().add(PauseEvent());
                          },
                        )),
                  )
                ],
              ),
            );
          } else {
            final currentStation = (state as PausedState).currentStation;
            return Container(
              height: 100,
              color: Theme.of(context).primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Image.network(currentStation.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        currentStation.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            size: 32,
                          ),
                          onPressed: () {
                            context.bloc<PlayerBloc>().add(PlayEvent(currentStation));
                          },
                        )),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
