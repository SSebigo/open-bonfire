import 'dart:io';

import 'package:bonfire/blocs/my_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/pages/my_profile/widgets/profile_picture_dialog.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  String _username = '';

  Map<String, dynamic> _dailyQuest;
  bool _completed;

  Map<String, dynamic> _skin;

  @override
  void initState() {
    _username = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUsername) as String;

    _dailyQuest =
        _localStorageRepository?.getUserSessionData(Constants.sessionDailyQuest)
            as Map<String, dynamic>;
    _completed = _localStorageRepository
        ?.getDailyQuestData(Constants.dailyQuestCompleted) as bool;

    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    super.initState();
  }

  void _showProfilePictureDialog(MyProfileState state) {
    String pictureUrl;

    if (state is STEProfilePictureUpdated) {
      pictureUrl = state.profilePictureUrl;
    } else {
      final tmpPictureUrl = _localStorageRepository
          ?.getUserSessionData(Constants.sessionProfilePictureUrl);

      pictureUrl = tmpPictureUrl == null || tmpPictureUrl.isEmpty as bool
          ? _skin['avatarIconUrl'] as String
          : tmpPictureUrl as String;
    }

    showDialog(
      context: context,
      builder: (_) => ProfilePictureDialog(
        pictureUrl: pictureUrl,
        buttonTitle: I18n.of(context).textEditProfilePicture,
        onPressed: _onProfilePictureClicked,
      ),
    );
  }

  Future<void> _onProfilePictureClicked() async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      BlocProvider.of<MyProfileBloc>(context)
          .add(EVTOnProfilePictureClicked(file: file));
    }
  }

  Widget _buildProfileAvatar(state) {
    final String pictureUrl = state is STEProfilePictureUpdated
        ? state.profilePictureUrl
        : _localStorageRepository
            ?.getUserSessionData(Constants.sessionProfilePictureUrl) as String;

    return CircularProfileAvatar(
      pictureUrl == null || pictureUrl.isEmpty
          ? _skin['avatarIconUrl'] as String
          : pictureUrl,
      backgroundColor: Colors.white,
      cacheImage: true,
      onTap: () => _showProfilePictureDialog(state as MyProfileState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              sailor(Constants.settingsRoute);
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: SafeArea(
        child: BlocListener<MyProfileBloc, MyProfileState>(
          listener: (context, state) {
            if (state is STEUpdatingProfilePicture) {
              Flushbar(
                message: I18n.of(context).textEditingProfilePicture,
                icon: Icon(Icons.file_upload, color: Colors.white),
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.white,
              ).show(context);
            }
          },
          child: BlocBuilder<MyProfileBloc, MyProfileState>(
            builder: (context, myProfileState) {
              return Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildProfileAvatar(myProfileState),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          _localStorageRepository?.getUserSessionData(
                              Constants.sessionName) as String,
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
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '@$_username',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Niveau: ${_localStorageRepository?.getUserSessionData(Constants.sessionLevel)}',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Tooltip(
                          message: I18n.of(context).textExperience,
                          child: Text(
                            'XP: ${_localStorageRepository?.getUserSessionData(Constants.sessionExperience)}/${_localStorageRepository?.getUserSessionData(Constants.sessionNextLevelExperience)}',
                            style: GoogleFonts.varelaRound(
                              textStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '${I18n.of(context).textBonfireLit}:',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${_localStorageRepository?.getUserSessionData(Constants.sessionBonfireCount)}',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () => sailor(Constants.profileFollowingRoute),
                          child: Text(
                            '${I18n.of(context).textMyFollowing}: ${_localStorageRepository?.getUserSessionData(Constants.sessionFollowing)?.length ?? 0}/100',
                            style: GoogleFonts.varelaRound(
                              textStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Button(
                          color: Theme.of(context).primaryColor,
                          elevation: 0.0,
                          height: 55.0,
                          text: I18n.of(context).textMyBonfires,
                          textColor: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                            ),
                          ),
                          onPressed: () =>
                              sailor(Constants.profileBonfiresRoute),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: _dailyQuest != null
                            ? Button(
                                color: Theme.of(context).primaryColor,
                                elevation: 0.0,
                                height: 55.0,
                                text:
                                    '${I18n.of(context).textDailyQuest} ${_completed == true ? I18n.of(context).textCompleted : I18n.of(context).textInProgress}',
                                textColor: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                width: double.infinity,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0,
                                  ),
                                ),
                                onPressed: () =>
                                    sailor(Constants.profileDQRoute),
                              )
                            : Button(
                                color: Theme.of(context).primaryColor,
                                elevation: 0.0,
                                height: 55.0,
                                text:
                                    '${I18n.of(context).textPenalty} ${I18n.of(context).textInProgress}',
                                textColor: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                width: double.infinity,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0,
                                  ),
                                ),
                                onPressed: () =>
                                    sailor(Constants.profilePenaltyRoute),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Button(
                          color: Theme.of(context).primaryColor,
                          elevation: 0.0,
                          height: 55.0,
                          text: I18n.of(context).textMyTrophies,
                          textColor: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          width: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                            ),
                          ),
                          onPressed: () =>
                              sailor(Constants.profileTrophiesRoute),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 20.0, vertical: 20.0),
                      //   child: MaterialButton(
                      //     onPressed: () =>
                      //         Navigator.of(context).pushNamed('/store'),
                      //     minWidth: double.infinity,
                      //     height: 50.0,
                      //     child: Text(
                      //       I18n.of(context).textStore,
                      //       style: TextStyle(
                      //         color: Theme.of(context).accentColor,
                      //         fontSize: 20.0,
                      //       ),
                      //     ),
                      //     color: Theme.of(context).primaryColor,
                      //     elevation: 5.0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      // ),
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
