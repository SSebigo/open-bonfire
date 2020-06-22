import 'package:bonfire/blocs/auth/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:bonfire/widgets/bonfire_text_form_field.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sailor/sailor.dart';

class SignInProblemPage extends StatefulWidget {
  @override
  _SignInProblemPageState createState() => _SignInProblemPageState();
}

class _SignInProblemPageState extends State<SignInProblemPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.addListener(_onEmailChanged);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isSendResetLinkEnabled() {
    return Validators.email(_emailController.text);
  }

  void _onEmailChanged() {
    BlocProvider.of<AuthBloc>(context)
        .add(OnEmailChanged(email: _emailController.text));
  }

  void _sendResetLink() {
    BlocProvider.of<AuthBloc>(context)
        .add(OnResetPasswordClicked(email: _emailController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          I18n.of(context).textForgotPassword,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          listener: (context, state) {
            if (state is ResetLinkSentState) {
              sailor.navigate(
                '/auth/reset-password-link-sent',
                navigationType: NavigationType.pushReplace,
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
            builder: (context, state) {
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0, bottom: 50.0),
                        child: Text(
                          I18n.of(context).textResetPasswordLink,
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
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 25.0),
                        child: BonfireTextFormField(
                          controller: _emailController,
                          labelText: I18n.of(context).textEmail,
                          hintText: I18n.of(context).textEmail,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).accentColor,
                          ),
                          autocorrect: true,
                          validator: (_) {
                            if (state is EmailValidityState) {
                              return !state.isEmailValid
                                  ? I18n.of(context).textInvalidEmail
                                  : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20.0),
                        child: Button(
                          color: PaletteOne.colorOne,
                          height: 55.0,
                          text: I18n.of(context).buttonSendResetLink,
                          textColor: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: _isSendResetLinkEnabled()
                              ? () => _sendResetLink()
                              : null,
                        ),
                      ),
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
