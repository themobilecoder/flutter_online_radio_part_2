import 'package:flutter/material.dart';

class StationListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget stationImage;
  final String name;

  StationListItem({this.onTap, @required this.stationImage, @required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 64,
              width: 64,
              child: stationImage,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
