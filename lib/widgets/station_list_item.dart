import 'package:flutter/material.dart';
import 'package:online_radio/widgets/station_favicon.dart';

class StationListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String imageUrl;
  final String name;

  StationListItem({this.onTap, @required this.imageUrl, @required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StationFavicon(
              imageUrl: imageUrl,
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
