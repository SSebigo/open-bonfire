import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompletedTrophyCard extends StatelessWidget {
  final double _height;
  final double _width;
  final String _iconUrl;
  final VoidCallback _onPressed;

  const CompletedTrophyCard({
    Key key,
    double height,
    double width,
    String iconUrl,
    VoidCallback onPressed,
  })  : _iconUrl = iconUrl,
        _height = height,
        _onPressed = onPressed,
        _width = width,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Container(
        height: _height,
        width: _width,
        child: CachedNetworkImage(
          filterQuality: FilterQuality.low,
          fit: BoxFit.contain,
          imageUrl: _iconUrl,
        ),
      ),
    );
  }
}
