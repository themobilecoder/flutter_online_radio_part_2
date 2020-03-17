import 'package:flutter/material.dart';

class LoadingIndicatorWithMessage extends StatelessWidget {
  final String label;
  LoadingIndicatorWithMessage({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text(label),
        ],
      ),
    );
  }
}
