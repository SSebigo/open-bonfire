import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightBonfireButton extends StatelessWidget {
  final VoidCallback _onTap;
  final String _imagePath;
  final String _text;

  const LightBonfireButton({
    Key key,
    @required VoidCallback onTap,
    @required String imagePath,
    @required String text,
  })  : _onTap = onTap,
        _imagePath = imagePath,
        _text = text,
        super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CachedNetworkImage(
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            height: 75.0,
            imageUrl: _imagePath,
            width: 75.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: GoogleFonts.varelaRound(
                textStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
