import 'package:bonfire/blocs/splash/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/pages/splash/splash_state_text.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<SplashBloc, SplashState>(
          bloc: BlocProvider.of<SplashBloc>(context),
          listener: (BuildContext context, SplashState state) {
            if (state is STENavigationToAnonymousSignIn) {
              sailor.navigate(Constants.authAnonymousRoute, navigationType: NavigationType.pushReplace);
            }
            if (state is STENavigationToMap) {
              sailor.navigate(Constants.mapRoute, navigationType: NavigationType.pushReplace);
            }
            if (state is STENavigationToCompleteProfile) {
              sailor.navigate(Constants.completeProfileRoute, navigationType: NavigationType.pushReplace);
            }
            if (state is STESplashError) {
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
          child: BlocBuilder<SplashBloc, SplashState>(
            bloc: BlocProvider.of<SplashBloc>(context),
            builder: (BuildContext context, SplashState state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Container(width: 250.0, height: 250.0, child: Image.asset('assets/img/logo.png'))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        I18n.of(context).textAppName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.varelaRound(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 5.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 75.0),
                    child: Container(width: double.infinity, child: SplashStateText(state: state)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
