import 'package:bonfire/blocs/auth/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  bool _isAnonymous;

  @override
  void initState() {
    _isAnonymous = _localStorageRepository
        ?.getUserSessionData(Constants.sessionIsAnonymous) as bool;

    super.initState();
  }

  RichText _policiesAcknowledgement() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 20.0,
          ),
        ),
        children: <TextSpan>[
          TextSpan(text: I18n.of(context).textAcceptOurTermsAlt),
          TextSpan(
            text: I18n.of(context).textTermsOfService,
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sailor(Constants.authTOSRoute),
          ),
          TextSpan(text: I18n.of(context).textAndOur),
          TextSpan(
            text: I18n.of(context).textPrivacyPolicy,
            style: TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sailor(Constants.authPPRoute),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          listener: (BuildContext context, AuthState state) {
            if (state is LoggingOutState) {
              Flushbar(
                message: I18n.of(context).textLoggingOut,
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is LoggedOutState) {
              sailor.navigate(
                Constants.authAnonymousRoute,
                navigationType: NavigationType.pushAndRemoveUntil,
                removeUntilPredicate: (_) => false,
              );
            }
            if (state is NavigateToMapState) {
              sailor.navigate(
                Constants.mapRoute,
                navigationType: NavigationType.pushReplace,
              );
            }
            if (state is NavigateToCompleteProfileState) {
              sailor.navigate(
                Constants.completeProfileRoute,
                navigationType: NavigationType.pushAndRemoveUntil,
                removeUntilPredicate: (_) => false,
              );
            }
            if (state is AuthErrorState) {
              Flushbar(
                title: I18n.of(context).textErrorOccured,
                message: state.error.message as String,
                duration: const Duration(seconds: 6),
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
            builder: (BuildContext context, AuthState state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: 250.0,
                        height: 250.0,
                        child: Image.asset('assets/img/logo.png'),
                      ),
                    ),
                    if (_isAnonymous != null && _isAnonymous == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Text(
                          I18n.of(context).textAccessProfile,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(),
                    _policiesAcknowledgement(),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
                      child: _isAnonymous != null && _isAnonymous == true
                          ? Button(
                              color: PaletteOne.colorOne,
                              height: 55.0,
                              text: I18n.of(context).buttonSignUp,
                              textColor: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              width: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () =>
                                  sailor(Constants.authSignupRoute),
                            )
                          : Button(
                              color: PaletteOne.colorOne,
                              height: 55.0,
                              text: I18n.of(context).buttonSignIn,
                              textColor: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              width: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () =>
                                  sailor(Constants.authSigninRoute),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: _isAnonymous != null && _isAnonymous == true
                              ? 75.0
                              : 15.0),
                      child: _isAnonymous != null && _isAnonymous == true
                          ? Button(
                              color: PaletteFour.colorThree,
                              height: 55.0,
                              text: I18n.of(context).textLogout,
                              textColor: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              width: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () =>
                                  BlocProvider.of<AuthBloc>(context)
                                    ..add(OnLogoutClicked()),
                            )
                          : Button(
                              color: PaletteOne.colorOne,
                              height: 55.0,
                              text: I18n.of(context).buttonSignUp,
                              textColor: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              width: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () =>
                                  sailor(Constants.authSignupRoute),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                      child: _isAnonymous != null && _isAnonymous == true
                          ? Container()
                          : GestureDetector(
                              onTap: () =>
                                  sailor(Constants.authSigninProblemRoute),
                              child: Text(
                                I18n.of(context).textForgotPassword,
                                style: GoogleFonts.varelaRound(
                                  textStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 15.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                    ),
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
