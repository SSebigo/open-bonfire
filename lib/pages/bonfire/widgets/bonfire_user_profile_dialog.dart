import 'package:bonfire/models/bonfire_user_details.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireUserProfileDialog extends StatefulWidget {
  final BonfireUserDetails _details;
  final String _buttonTitle;
  final VoidCallback _onPressed;
  final double _width;
  final double _height;
  final bool _isAnonymous;
  final bool _isCurrentUser;
  final bool _isFollowing;
  final Color _buttonColor;

  const BonfireUserProfileDialog({
    Key key,
    @required BonfireUserDetails details,
    String buttonTitle,
    VoidCallback onPressed,
    double width,
    double height,
    @required bool isAnonymous,
    @required bool isCurrentUser,
    @required bool isFollowing,
    Color buttonColor,
  })  : _details = details,
        _buttonTitle = buttonTitle,
        _onPressed = onPressed,
        _width = width,
        _height = height,
        _isAnonymous = isAnonymous,
        _isCurrentUser = isCurrentUser,
        _isFollowing = isFollowing,
        _buttonColor = buttonColor,
        super(key: key);

  @override
  _BonfireUserProfileDialogState createState() =>
      _BonfireUserProfileDialogState();
}

class _BonfireUserProfileDialogState extends State<BonfireUserProfileDialog> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  Map<String, dynamic> _skin;

  @override
  void initState() {
    _skin = _localStorageRepository?.getSkinData(Constants.skin)
        as Map<String, dynamic>;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: widget._width,
        height: widget._height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircularProfileAvatar(
                  widget._details.photoUrl == null ||
                          widget._details.photoUrl.isEmpty
                      ? _skin['avatarIconUrl'] as String
                      : widget._details.photoUrl,
                  radius: 75.0,
                  backgroundColor: Colors.white,
                  cacheImage: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                widget._details.name,
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
                '@${widget._details.username}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.varelaRound(
                  textStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            if (widget._isAnonymous == true || widget._isCurrentUser)
              Container()
            else
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    onPressed: widget._onPressed,
                    elevation: widget._isFollowing == true ? 0.0 : 2.0,
                    color: widget._buttonColor,
                    shape: RoundedRectangleBorder(
                      side: widget._isFollowing
                          ? BorderSide(
                              color: Theme.of(context).accentColor,
                            )
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      widget._buttonTitle,
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
