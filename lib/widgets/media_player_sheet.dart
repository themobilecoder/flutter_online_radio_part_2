import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MediaPlayerSheet extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Function onMediaButtonPress;
  final Icon mediaButtonIcon;
  final Color backgroundColor;

  MediaPlayerSheet({
    @required this.imageUrl,
    @required this.title,
    @required this.onMediaButtonPress,
    @required this.mediaButtonIcon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: backgroundColor ?? Theme.of(context).primaryColor,
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
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
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                title,
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
                  icon: mediaButtonIcon,
                  onPressed: onMediaButtonPress,
                )),
          )
        ],
      ),
    );
  }
}
