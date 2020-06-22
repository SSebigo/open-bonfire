import 'package:bonfire/blocs/settings/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:bonfire/widgets/bonfire_dialog.dart';
import 'package:bonfire/widgets/bonfire_text_form_field.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNamePage extends StatefulWidget {
  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    _nameController.text =
        _localStorageRepository?.getUserSessionData(Constants.sessionName) as String;

    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    BlocProvider.of<SettingsBloc>(context)
      .add(OnNameChanged(name: _nameController.text));
  }

  void _onPasswordChanged() {
    BlocProvider.of<SettingsBloc>(context)
      .add(OnPasswordChanged(password: _passwordController.text));
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => BonfireDialog(
        title:
            '${I18n.of(context).textSureModify} ${I18n.of(context).textName.toLowerCase()}${I18n.of(context).textQuestionMark}',
        titleButton1: I18n.of(context).buttonCancel,
        onPressedButton1: () {
          Navigator.of(context).pop();
        },
        titleButton2: I18n.of(context).buttonImSure,
        onPressedButton2: _updateName,
        width: 300.0,
        height: 200.0,
      ),
    );
  }

  bool _isEditNameEnabled() {
    return Validators.name(_nameController.text) &&
        Validators.password(_passwordController.text);
  }

  void _updateName() {
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<SettingsBloc>(context)
      .add(OnModifyNameClicked(
          name: _nameController.text,
          password: _passwordController.text,
          errorMessage: I18n.of(context).textInvalidProvidedPassword));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          I18n.of(context).textUpdateMyName,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is ModifyingFieldState) {
              Flushbar(
                message: I18n.of(context).textUpdatingName,
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is FieldModifiedState) {
              _passwordController.text = '';
              Flushbar(
                message: I18n.of(context).textNameUpdated,
                icon:
                    Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.greenAccent,
              ).show(context);
            }
            if (state is SettingsFailedState) {
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
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: BonfireTextFormField(
                          controller: _nameController,
                          labelText: I18n.of(context).textName,
                          hintText: I18n.of(context).textNewName,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          validator: (_) {
                            if (state is NameValidityState) {
                              return !state.isNameValid
                                  ? I18n.of(context).textInvalidName
                                  : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 50.0),
                        child: BonfireTextFormField(
                          controller: _passwordController,
                          labelText: I18n.of(context).textPassword,
                          hintText: I18n.of(context).textPassword,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          obscureText: true,
                          errorMaxLines: 6,
                          validator: (_) {
                            if (state is PasswordValidityState) {
                              return !state.isPasswordValid
                                  ? I18n.of(context).textInvalidPassword
                                  : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Button(
                          color: PaletteOne.colorOne,
                          height: 60.0,
                          text:
                              '${I18n.of(context).buttonUpdateMy} ${I18n.of(context).textName.toLowerCase()}',
                          textColor: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: _isEditNameEnabled()
                              ? _showConfirmationDialog
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
