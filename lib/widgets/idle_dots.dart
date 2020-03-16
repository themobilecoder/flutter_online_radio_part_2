import 'package:flutter/material.dart';

class IdleDots extends StatelessWidget {
  final Color color;
  IdleDots({this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(5, (_) {
      return Padding(
        padding: const EdgeInsets.all(0.8),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).accentColor),
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
