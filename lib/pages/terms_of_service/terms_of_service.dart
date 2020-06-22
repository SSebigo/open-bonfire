import 'package:bonfire/i18n.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          I18n.of(context).textTermsOfService,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          I18n.of(context).textTermsOfServiceContent,
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
