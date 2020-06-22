import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireRatingButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _imagePath;
  final List<String> _ratings;
  final Color _color;
  final String _sessionUid;

  const BonfireRatingButton({
    Key key,
    VoidCallback onPressed,
    String imagePath,
    List<String> ratings,
    Color color,
    String sessionUid,
  })  : _onPressed = onPressed,
        _imagePath = imagePath,
        _ratings = ratings,
        _color = color,
        _sessionUid = sessionUid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              '${_ratings.length}',
              style: GoogleFonts.varelaRound(
                textStyle: TextStyle(
                  color: _ratings.contains(_sessionUid)
                      ? _color
                      : Theme.of(context).accentColor,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          CachedNetworkImage(
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            height: 75.0,
            imageUrl: _imagePath,
            width: 75.0,
          ),
        ],
      ),
    );
  }
}
