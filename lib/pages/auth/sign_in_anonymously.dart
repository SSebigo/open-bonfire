import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bonfire/blocs/auth/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_dialog.dart';
import 'package:bonfire/widgets/bonfire_loading_screen.dart';
import 'package:bonfire/widgets/button.dart';

class SignInAnonymouslyPage extends StatefulWidget {
  @override
  _SignInAnonymouslyPageState createState() => _SignInAnonymouslyPageState();
}

class _SignInAnonymouslyPageState extends State<SignInAnonymouslyPage> with TickerProviderStateMixin {
  RichText _policiesAcknowledgement() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(color: Theme.of(context).accentColor, fontSize: 20.0),
        ),
        children: <TextSpan>[
          TextSpan(text: I18n.of(context).textAcceptOurTerms),
          TextSpan(
            text: I18n.of(context).textTermsOfService,
            style: TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = () => sailor(Constants.authTOSRoute),
          ),
          TextSpan(text: I18n.of(context).textAndOur),
          TextSpan(
            text: I18n.of(context).textPrivacyPolicy,
            style: TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = () => sailor(Constants.authPPRoute),
          ),
        ],
      ),
    );
  }

  GestureDetector _alreadyHaveAnAccountLink() {
    return GestureDetector(
      onTap: () => sailor(Constants.authRoute),
      child: Text(
        I18n.of(context).textHaveAccount,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 15.0,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _showConfirmSignInAnonymouslyDialog() {
    showDialog(
      context: context,
      builder: (_) => BonfireDialog(
        title: I18n.of(context).textContinueAnonymous,
        description: RichText(
          text: TextSpan(
            style: GoogleFonts.varelaRound(
              textStyle: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
            ),
            children: <TextSpan>[
              TextSpan(text: '${I18n.of(context).textAnonymousDisclaimer1}:\n'),
              TextSpan(text: '${I18n.of(context).textAnonymousDisclaimer2}\n'),
              TextSpan(text: I18n.of(context).textAnonymousDisclaimer3),
            ],
          ),
        ),
        titleButton1: I18n.of(context).buttonCancel,
        onPressedButton1: () => Navigator.of(context).pop(true),
        titleButton2: I18n.of(context).buttonNext,
        onPressedButton2: () {
          BlocProvider.of<AuthBloc>(context).add(OnSignInAnonymouslyClicked());
          Navigator.of(context).pop(true);
        },
        width: 350.0,
        height: 350.0,
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          listener: (context, state) {
            if (state is SignedInAnonymously) {
              sailor(Constants.mapRoute);
            }
            if (state is AuthErrorState) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message: state.error.message as String,
                icon: Icon(Icons.error_outline, color: Colors.redAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: BlocProvider.of<AuthBloc>(context),
            builder: (context, state) {
              if (state is SigningInAnonymously) {
                return BonfireLoadingScreen(vsync: this, isLoading: state is SigningInAnonymously);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(width: 250.0, height: 250.0, child: Image.asset('assets/img/logo.png')),
                    ),
                    _policiesAcknowledgement(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Button(
                        color: PaletteOne.colorOne,
                        height: 55.0,
                        text: I18n.of(context).buttonSignAnonymous,
                        textColor: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        width: double.infinity,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        onPressed: _showConfirmSignInAnonymouslyDialog,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(bottom: 100.0), child: _alreadyHaveAnAccountLink()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
