import 'package:bonfire/models/trophy.dart';
import 'package:bonfire/pages/my_profile/widgets/completed_trophy_card.dart';
import 'package:bonfire/pages/my_profile/widgets/incompleted_trophy_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrophyDialog extends StatelessWidget {
  final bool _completed;
  final String _locale;
  final Trophy _trophy;

  const TrophyDialog({
    Key key,
    bool completed,
    String locale,
    Trophy trophy,
  })  : _completed = completed,
        _locale = locale,
        _trophy = trophy,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: _completed == true
                  ? CompletedTrophyCard(
                      iconUrl: _trophy.iconUrl,
                      height: 100.0,
                      width: 100.0,
                    )
                  : IncompletedTrophyCard(
                      iconUrl: _trophy.iconUrl,
                      height: 100.0,
                      width: 100.0,
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 25.0),
              child: Text(
                _trophy.title[_locale],
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                  textStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 25.0),
              child: Text(
                _completed ? _trophy.description[_locale] : '??????',
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                  textStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
