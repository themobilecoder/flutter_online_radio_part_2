import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StationFavicon extends StatelessWidget {
  static const String DEFAULT_ICON = 'assets/images/music.svg';

  final String imageUrl;
  final int height;
  final int width;

  StationFavicon({@required this.imageUrl, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height ?? 48,
      width: width ?? 48,
      imageUrl: imageUrl,
      placeholder: (context, _) {
        return SvgPicture.asset(
          DEFAULT_ICON,
          height: height ?? 48,
          width: width ?? 48,
          semanticsLabel: 'Music',
          color: Theme.of(context).textTheme.body1.color,
        );
      },
      errorWidget: (context, _, __) {
        return SvgPicture.asset(
          DEFAULT_ICON,
          height: height ?? 48,
          width: width ?? 48,
          semanticsLabel: 'Music',
          color: Theme.of(context).textTheme.body1.color,
        );
      },
    );
  }
}