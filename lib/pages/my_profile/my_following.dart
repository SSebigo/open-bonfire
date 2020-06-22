import 'package:bonfire/blocs/my_profile/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFollowingPage extends StatefulWidget {
  @override
  _MyFollowingPageState createState() => _MyFollowingPageState();
}

class _MyFollowingPageState extends State<MyFollowingPage> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Map<String, dynamic> _skin;

  @override
  void initState() {
    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    final List<String> following = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFollowing) as List<String>;

    BlocProvider.of<MyProfileBloc>(context)
        .add(EVTOnFetchFollowingDetails(following: following));

    super.initState();
  }

  void _goBack() {
    BlocProvider.of<MyProfileBloc>(context).add(EVTOnGoBackClicked());
  }

  Widget _buildProfileAvatar(String profilePictureUrl) {
    return CircularProfileAvatar(
      profilePictureUrl == null || profilePictureUrl == ''
          ? _skin['avatarIconUrl'] as String
          : profilePictureUrl,
      radius: 25.0,
      backgroundColor: Colors.white,
      cacheImage: true,
    );
  }

  void _unfollow(String unfollowingUid) {
    BlocProvider.of<MyProfileBloc>(context)
        .add(EVTOnUnfollowClicked(unfollowingUid: unfollowingUid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
          ),
          onPressed: _goBack,
        ),
        title: Text(
          I18n.of(context).textMyFollowing,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<MyProfileBloc, MyProfileState>(
          listener: (context, state) {
            if (state is STEGoingBack) {
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<MyProfileBloc, MyProfileState>(
            builder: (context, state) {
              if (state is STEFetchedFollowingDetails) {
                return state.following.isEmpty
                    ? Center(
                        child: Text(
                          I18n.of(context).textNothingHere,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.following.length,
                        itemBuilder: (_, int idx) {
                          return ListTile(
                            leading: _buildProfileAvatar(
                                state.following[idx].photoUrl),
                            title: Text(
                              state.following[idx].name,
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              '@${state.following[idx].username}',
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            trailing: MaterialButton(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () =>
                                  _unfollow(state.following[idx].uid),
                              child: Text(
                                I18n.of(context).textFollowing,
                                style: GoogleFonts.varelaRound(
                                  textStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }
              if (state is STEFollowingRemoved) {
                return state.following.isEmpty
                    ? Center(
                        child: Text(
                          I18n.of(context).textNothingHere,
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.following.length,
                        itemBuilder: (_, int idx) {
                          return ListTile(
                            leading: _buildProfileAvatar(
                                state.following[idx].photoUrl),
                            title: Text(
                              state.following[idx].name,
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              '@${state.following[idx].username}',
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            trailing: MaterialButton(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () =>
                                  _unfollow(state.following[idx].uid),
                              child: Text(
                                I18n.of(context).textFollowing,
                                style: GoogleFonts.varelaRound(
                                  textStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
