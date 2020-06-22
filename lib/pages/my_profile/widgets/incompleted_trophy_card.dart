import 'package:flutter/material.dart';

class IncompletedTrophyCard extends StatelessWidget {
  final double _height;
  final double _width;
  final String _iconUrl;
  final VoidCallback _onPressed;

  const IncompletedTrophyCard({
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
        child: ColorFiltered(
          colorFilter:
              ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.color),
          child: Image.network(
            _iconUrl,
            filterQuality: FilterQuality.low,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
