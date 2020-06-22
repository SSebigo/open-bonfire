import 'dart:io';

import 'package:bonfire/blocs/complete_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_text_form_field.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sailor/sailor.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File _file;

  Map<String, dynamic> _skin;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
    _nameController.addListener(_onNameChanged);
    setState(() {
      _nameController.text = _localStorageRepository
          ?.getUserSessionData(Constants.sessionName) as String;
    });

    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isStartEnabled() {
    return _usernameController.text.length >= 4 &&
        _nameController.text.length >= 2;
  }

  void _onUsernameChanged() {
    BlocProvider.of<CompleteProfileBloc>(context)
        .add(OnUsernameChanged(username: _usernameController.text));
  }

  void _onNameChanged() {
    BlocProvider.of<CompleteProfileBloc>(context)
        .add(OnNameChanged(name: _nameController.text));
  }

  Future<void> _onProfilePictureClicked() async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  void _start() {
    BlocProvider.of<CompleteProfileBloc>(context).add(OnSaveProfileClicked(
        pictureFile: _file,
        username: _usernameController.text,
        name: _nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(
          I18n.of(context).textCompleteProfile,
          style: GoogleFonts.varelaRound(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<CompleteProfileBloc, CompleteProfileState>(
          listener: (context, state) {
            if (state is SavingProfileState) {
              Flushbar(
                message: I18n.of(context).textSavingProfile,
                duration: const Duration(seconds: 3),
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
            if (state is ProfileSavedState) {
              FocusScope.of(context).requestFocus(FocusNode());
              sailor.navigate(
                Constants.mapRoute,
                navigationType: NavigationType.pushAndRemoveUntil,
                removeUntilPredicate: (_) => false,
              );
            }
            if (state is SaveProfileFailedState) {
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
          child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (context, state) {
              return Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: CircularProfileAvatar(
                          '',
                          radius: 75.0,
                          backgroundColor: Colors.white,
                          cacheImage: true,
                          onTap: _onProfilePictureClicked,
                          child: _file == null
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.contain,
                                  imageUrl: _skin['avatarIconUrl'] as String,
                                )
                              : Image.file(_file),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                        child: Text(
                          I18n.of(context).textProfilePicture,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: BonfireTextFormField(
                          controller: _usernameController,
                          labelText: I18n.of(context).textUsername,
                          hintText: I18n.of(context).textUsername,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          ),
                          autocorrect: true,
                          validator: (_) {
                            if (state is UsernameValidityState) {
                              return !state.isUsernameValid
                                  ? I18n.of(context).textInvalidUsername
                                  : null;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: BonfireTextFormField(
                          controller: _nameController,
                          labelText: I18n.of(context).textName,
                          hintText: I18n.of(context).textName,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          ),
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
                            left: 20.0, top: 50.0, right: 20.0, bottom: 20.0),
                        child: Button(
                          color: PaletteOne.colorOne,
                          height: 55.0,
                          text: I18n.of(context).start,
                          textColor: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: _isStartEnabled() ? () => _start() : null,
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
