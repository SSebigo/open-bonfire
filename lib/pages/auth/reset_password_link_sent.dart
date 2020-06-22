import 'package:bonfire/i18n.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

class ResetPasswordLinkSentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Text(
                  I18n.of(context).textResetLinkSent,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
                child: Button(
                  color: PaletteOne.colorOne,
                  height: 55.0,
                  text: I18n.of(context).buttonSignIn,
                  textColor: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  width: double.infinity,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () => sailor.navigate(
                    Constants.authSigninRoute,
                    navigationType: NavigationType.pushReplace,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
