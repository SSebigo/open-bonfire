import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyQuestPenaltyButton extends StatelessWidget {
  final double _height, _width;
  final String _imagePath, _tooltipMessage;
  final VoidCallback _onPressed;

  const DailyQuestPenaltyButton({
    double height,
    double width,
    String imagePath,
    String tooltipMessage,
    VoidCallback onPressed,
    Key key,
  })  : _height = height,
        _width = width,
        _imagePath = imagePath,
        _tooltipMessage = tooltipMessage,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltipMessage,
      textStyle: GoogleFonts.varelaRound(
        textStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        onTap: _onPressed,
        child: Container(
          width: _width,
          height: _height,
          child: CachedNetworkImage(
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            height: _height,
            imageUrl: _imagePath,
            width: _width,
          ),
        ),
      ),
    );
  }
}
