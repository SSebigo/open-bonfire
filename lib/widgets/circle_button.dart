import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback _onTap;
  final double _height, _width;
  final String _imagePath;

  const CircleButton({
    Key key,
    VoidCallback onTap,
    double height,
    double width,
    String imagePath,
  })  : _onTap = onTap,
        _height = height,
        _imagePath = imagePath,
        _width = width,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: _width,
        height: _height,
        child: CachedNetworkImage(
          color: _onTap == null ? Colors.black12 : null,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          height: _height,
          imageUrl: _imagePath,
          width: _width,
        ),
      ),
    );
  }
}
