import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  final String title;
  final Widget status;

  TitleHeader({
    this.title,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          status,
        ],
      ),
    );
  }
}
