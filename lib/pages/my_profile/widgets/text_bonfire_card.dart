import 'package:bonfire/models/bonfire.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextBonfireCard extends StatelessWidget {
  final DateTime _now;
  final TextBonfire _bonfire;
  final String _imagePath, _locale;
  final VoidCallback _onPressed;

  const TextBonfireCard({
    Key key,
    DateTime now,
    String imagePath,
    String locale,
    TextBonfire bonfire,
    VoidCallback onPressed,
  })  : _now = now,
        _bonfire = bonfire,
        _imagePath = imagePath,
        _locale = locale,
        _onPressed = onPressed,
        super(key: key);

  String _getElapsedTimeSinceShared(int timestamp) {
    return timeago.format(
        _now.subtract(
            _now.difference(DateTime.fromMillisecondsSinceEpoch(timestamp))),
        locale: _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
        onTap: _onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 2.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      height: 50.0,
                      imageUrl: _imagePath,
                      width: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: Text(
                  _bonfire.text,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: Text(
                  _getElapsedTimeSinceShared(_bonfire.createdAt),
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
        ),
      ),
    );
  }
}
