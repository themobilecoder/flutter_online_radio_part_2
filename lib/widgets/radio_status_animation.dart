import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

class PausedStatus extends StatelessWidget {
  final Color color;
  PausedStatus({this.color});

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(5, (_) {
      return Padding(
        padding: const EdgeInsets.all(0.8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? Theme.of(context).accentColor,
          ),
          height: 4,
          width: 4,
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}

class PlayingStatus extends StatelessWidget {
  final Color color;

  PlayingStatus({this.color});

  @override
  Widget build(BuildContext context) {
    return Loading(
      indicator: LineScalePulseOutIndicator(),
      size: 30,
      color: color ?? Theme.of(context).accentColor,
    );
  }
}
