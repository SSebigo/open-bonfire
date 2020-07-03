import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

import 'package:bonfire/blocs/auth/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:bonfire/widgets/bonfire_loading_screen.dart';
import 'package:bonfire/widgets/bonfire_text_form_field.dart';
import 'package:bonfire/widgets/button.dart';

class SignInWithEmailPage extends StatefulWidget {
  @override
  _SignInWithEmailPageState createState() => _SignInWithEmailPageState();
}

class _SignInWithEmailPageState extends State<SignInWithEmailPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isSignInEnabled() {
    return Validators.email(_emailController.text) && Validators.password(_passwordController.text);
  }

  void _onEmailChanged() {
    BlocProvider.of<AuthBloc>(context).add(OnEmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    BlocProvider.of<AuthBloc>(context).add(OnPasswordChanged(password: _passwordController.text));
  }

  void _signIn() {
    BlocProvider.of<AuthBloc>(context)
        .add(OnSignInClicked(email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          I18n.of(context).buttonSignIn,
          style: GoogleFonts.varelaRound(textStyle: TextStyle(color: Theme.of(context).accentColor)),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          listener: (BuildContext context, AuthState state) {
            if (state is NavigateToMapState) {
              FocusScope.of(context).requestFocus(FocusNode());
              sailor.navigate(Constants.mapRoute, navigationType: NavigationType.pushReplace);
            }
            if (state is NavigateToCompleteProfileState) {
              FocusScope.of(context).requestFocus(FocusNode());
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
              if (state is LoggingInState) {
                return BonfireLoadingScreen(vsync: this, isLoading: state is LoggingInState);
              }
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                        child: BonfireTextFormField(
                          controller: _emailController,
                          labelText: I18n.of(context).textEmail,
                          hintText: I18n.of(context).textEmail,
                          prefixIcon: Icon(Icons.email, color: Theme.of(context).accentColor),
                          autocorrect: true,
                          validator: (_) {
                            if (state is EmailValidityState) {
                              return !state.isEmailValid ? I18n.of(context).textInvalidEmail : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: BonfireTextFormField(
                          controller: _passwordController,
                          labelText: I18n.of(context).textPassword,
                          hintText: I18n.of(context).textPassword,
                          prefixIcon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                          obscureText: true,
                          errorMaxLines: 6,
                          validator: (_) {
                            if (state is PasswordValidityState) {
                              return !state.isPasswordValid ? I18n.of(context).textInvalidPassword : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                        child: Button(
                          color: PaletteOne.colorOne,
                          height: 55.0,
                          text: I18n.of(context).buttonNext,
                          textColor: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          onPressed: _isSignInEnabled() ? _signIn : null,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
