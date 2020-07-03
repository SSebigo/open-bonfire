import 'package:bonfire/blocs/splash/splash_state.dart';
import 'package:bonfire/i18n.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashStateText extends StatelessWidget {
  final SplashState state;

  const SplashStateText({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is STEPermissionsRequestPending) {
      return Text(
        I18n.of(context).textPermissionRequest,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (state is STEPermissionsRequestDenied) {
      return Text(
        I18n.of(context).textPermissionDenied,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Container();
  }
}
