import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireHeader extends StatelessWidget {
  final VoidCallback _onTap;
  final String _authorName,
      _authorUsername,
      _defaultPictureUrl,
      _profilePictureUrl;

  const BonfireHeader({
    VoidCallback onTap,
    String authorName,
    String authorUsername,
    String defaultPictureUrl,
    String profilePictureUrl,
    Key key,
  })  : _onTap = onTap,
        _authorName = authorName,
        _authorUsername = authorUsername,
        _defaultPictureUrl = defaultPictureUrl,
        _profilePictureUrl = profilePictureUrl,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularProfileAvatar(
        _profilePictureUrl == null || _profilePictureUrl == ''
            ? _defaultPictureUrl
            : _profilePictureUrl,
        radius: 25.0,
        backgroundColor: Colors.white,
        cacheImage: true,
      ),
      title: Text(
        _authorName,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: GestureDetector(
        onTap: _onTap,
        child: Text(
          '@$_authorUsername',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
