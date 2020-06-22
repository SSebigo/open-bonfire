import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePictureDialog extends StatelessWidget {
  final String _pictureUrl;
  final String _buttonTitle;
  final VoidCallback _onPressed;

  const ProfilePictureDialog({
    Key key,
    @required String pictureUrl,
    String buttonTitle,
    VoidCallback onPressed,
  })  : _pictureUrl = pictureUrl,
        _buttonTitle = buttonTitle,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircularProfileAvatar(
                  _pictureUrl,
                  radius: 75.0,
                  backgroundColor: Colors.white,
                  cacheImage: true,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  color: PaletteOne.colorOne,
                  fontWeight: FontWeight.bold,
                  height: 35.0,
                  onPressed: _onPressed,
                  shape: const StadiumBorder(),
                  text: _buttonTitle,
                  textColor: Colors.black,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
