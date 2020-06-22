import 'package:bonfire/blocs/bonfire/bloc.dart';
import 'package:bonfire/i18n.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/models/bonfire_user_details.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_body.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_header.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_user_profile_dialog.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/routes.dart';
import 'package:bonfire/utils/arguments.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/bonfire_rating_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BonfirePage extends StatefulWidget {
  final BonfireArgs args;

  const BonfirePage({Key key, this.args}) : super(key: key);

  @override
  _BonfirePageState createState() => _BonfirePageState();
}

class _BonfirePageState extends State<BonfirePage>
    with SingleTickerProviderStateMixin {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  String _sessionUid;

  bool _sessionIsAnonymous;

  Map<String, dynamic> _skin;

  BonfireUserDetails _userDetails;

  @override
  void initState() {
    _sessionUid = _localStorageRepository
        ?.getUserSessionData(Constants.sessionUid) as String;

    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    if (_sessionUid == widget.args.bonfire.authorUid) {
      final int sessionExperience = _localStorageRepository
          ?.getUserSessionData(Constants.sessionExperience) as int;
      final int sessionLevel = _localStorageRepository
          ?.getUserSessionData(Constants.sessionLevel) as int;
      final String sessionProfilePictureUrl = _localStorageRepository
          ?.getUserSessionData(Constants.sessionProfilePictureUrl) as String;
      final String sessionName = _localStorageRepository
          ?.getUserSessionData(Constants.sessionName) as String;
      final String sessionUsername = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUsername) as String;
      final List<String> sessionTrophies = _localStorageRepository
          ?.getUserSessionData(Constants.sessionTrophies) as List<String>;

      _userDetails = BonfireUserDetails(
        experience: sessionExperience,
        level: sessionLevel,
        photoUrl: sessionProfilePictureUrl,
        name: sessionName,
        trophies: sessionTrophies,
        uid: _sessionUid,
        username: sessionUsername,
      );
    } else {
      _userDetails = BonfireUserDetails(
        experience: 0,
        level: 0,
        photoUrl: _skin['avatarIconUrl'] as String,
        name: '',
        trophies: null,
        uid: '',
        username: '',
      );

      BlocProvider.of<BonfireBloc>(context).add(EVTOnFetchBonfireUserDetails(
        authorUid: widget.args.bonfire.authorUid,
      ));
    }

    _sessionIsAnonymous = _localStorageRepository
        ?.getUserSessionData(Constants.sessionIsAnonymous) as bool;

    super.initState();
  }

  void _goBack() {
    BlocProvider.of<BonfireBloc>(context).add(EVTOnGoBackClicked());
  }

  void _onBonfireLikeClicked(Bonfire bonfire) {
    BlocProvider.of<BonfireBloc>(context).add(EVTOnBonfireLiked(
      id: bonfire.id,
      sessionUid: _sessionUid,
      likes: bonfire.likes,
      dislikes: bonfire.dislikes,
    ));
  }

  void _onBonfireDislikeClicked(Bonfire bonfire) {
    BlocProvider.of<BonfireBloc>(context).add(EVTOnBonfireDisliked(
      id: bonfire.id,
      sessionUid: _sessionUid,
      likes: bonfire.likes,
      dislikes: bonfire.dislikes,
    ));
  }

  bool _isCurrentUser() {
    return widget.args.bonfire.authorUid == _sessionUid;
  }

  bool _isAnonymousBonfire() {
    return _userDetails.username.split('-')[0] == 'anonymous';
  }

  bool _isCurrentUserAlreadyFollowingBonfireAuthor() {
    final List<String> following = _localStorageRepository
        ?.getUserSessionData(Constants.sessionFollowing) as List<String>;
    return following?.contains(_userDetails.uid) ?? false;
  }

  void _followBonfireAuthor() {
    BlocProvider.of<BonfireBloc>(context).add(EVTOnFollowClicked(
      followingUid: widget.args.bonfire.authorUid,
      errorMessage: I18n.of(context).textFollowingLimitReached,
    ));
  }

  void _unfollowBonfireAuthor() {
    BlocProvider.of<BonfireBloc>(context).add(EVTOnUnfollowClicked(
      unfollowingUid: widget.args.bonfire.authorUid,
    ));
  }

  String _getFollowingText(BonfireState state) {
    if (state is STEFollowingAdded) {
      return I18n.of(context).buttonFollowing;
    } else if (state is STEFollowingRemoved) {
      return I18n.of(context).buttonFollow;
    }
    return _isCurrentUserAlreadyFollowingBonfireAuthor()
        ? I18n.of(context).buttonFollowing
        : I18n.of(context).buttonFollow;
  }

  Function() _getFollowingMethod(BonfireState state) {
    if (state is STEFollowingAdded) {
      return _unfollowBonfireAuthor;
    } else if (state is STEFollowingRemoved) {
      return _followBonfireAuthor;
    }
    return _isCurrentUserAlreadyFollowingBonfireAuthor()
        ? _unfollowBonfireAuthor
        : _followBonfireAuthor;
  }

  Color _getFollowingButtonColor(BonfireState state) {
    if (state is STEFollowingAdded) {
      return Theme.of(context).primaryColor;
    } else if (state is STEFollowingRemoved) {
      return PaletteOne.colorOne;
    }
    return _isCurrentUserAlreadyFollowingBonfireAuthor()
        ? Theme.of(context).primaryColor
        : PaletteOne.colorOne;
  }

  bool _getIsFollowing(BonfireState state) {
    if (state is STEFollowingAdded) {
      return true;
    } else if (state is STEFollowingRemoved) {
      return false;
    }
    return _isCurrentUserAlreadyFollowingBonfireAuthor();
  }

  void _showUserProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocBuilder<BonfireBloc, BonfireState>(
        builder: (context, state) {
          return BonfireUserProfileDialog(
            details: _userDetails,
            buttonTitle: _getFollowingText(state),
            onPressed: _getFollowingMethod(state),
            buttonColor: _getFollowingButtonColor(state),
            width: 300.0,
            height: _sessionIsAnonymous == true ||
                    _isCurrentUser() == true ||
                    _isAnonymousBonfire() == true
                ? 325.0
                : 400.0,
            isAnonymous: _sessionIsAnonymous || _isAnonymousBonfire(),
            isCurrentUser: _isCurrentUser(),
            isFollowing: _getIsFollowing(state),
          );
        },
      ),
    );
  }

  Widget _buildRatingView() {
    return SlidingUpPanel(
      minHeight: 50.0,
      maxHeight: 175.0,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 5.0,
          color: Color.fromRGBO(0, 0, 0, 0.25),
          spreadRadius: 2.0,
        )
      ],
      backdropEnabled: true,
      collapsed: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Center(
          child: Container(
            width: 35.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
      panel: Container(
        width: double.infinity,
        height: 150.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BonfireRatingButton(
                  onPressed: () => _onBonfireLikeClicked(widget.args.bonfire),
                  imagePath: _skin['likeIconUrl'] as String,
                  ratings: widget.args.bonfire.likes,
                  color: Colors.greenAccent,
                  sessionUid: _sessionUid,
                ),
                Text(
                  '${widget.args.bonfire.likes.length - widget.args.bonfire.dislikes.length}',
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                BonfireRatingButton(
                  onPressed: () =>
                      _onBonfireDislikeClicked(widget.args.bonfire),
                  imagePath: _skin['dislikeIconUrl'] as String,
                  ratings: widget.args.bonfire.dislikes,
                  color: Colors.redAccent,
                  sessionUid: _sessionUid,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      ),
      body: SafeArea(
        child: BlocListener<BonfireBloc, BonfireState>(
          listener: (context, state) {
            if (state is STEGoingBack) {
              Navigator.of(context).pop();
            }
            if (state is STENavigated) {
              sailor.navigate(
                Constants.bonfireImageRoute,
                args: VisualBonfireArgs(
                  widget.args.bonfire,
                  color: state.color,
                ),
              );
            }
            if (state is STEBonfireUpdated) {
              widget.args.bonfire.likes = state.likes;
              widget.args.bonfire.dislikes = state.dislikes;
            }
            if (state is STEFileDownloaded) {
              Navigator.of(context).pop();
              Flushbar(
                message: I18n.of(context).textFileDownloaded,
                duration: const Duration(seconds: 3),
                icon:
                    Icon(Icons.check_circle_outline, color: Colors.greenAccent),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: const EdgeInsets.all(8),
                borderRadius: 8,
                leftBarIndicatorColor: Colors.greenAccent,
              ).show(context);
            }
            if (state is BonfireErrorState) {
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
          child: BlocBuilder<BonfireBloc, BonfireState>(
            builder: (context, state) {
              if (state is STEFetchedBonfireUserDetails) {
                _userDetails = state.userDetails;
              }
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        BonfireHeader(
                          authorName: _userDetails?.name,
                          authorUsername: _userDetails?.username,
                          defaultPictureUrl: _skin['avatarIconUrl'] as String,
                          profilePictureUrl: _userDetails?.photoUrl,
                          onTap: _showUserProfileDialog,
                        ),
                        BonfireBody(bonfire: widget.args.bonfire, state: state),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _sessionIsAnonymous == true
                        ? Container()
                        : _buildRatingView(),
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
