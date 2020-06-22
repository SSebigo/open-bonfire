import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_description.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_image.dart';
import 'package:flutter/material.dart';

class BonfireImageBody extends StatelessWidget {
  final VoidCallback _onPressed;
  final ImageBonfire _bonfire;
  final Widget _loading;

  const BonfireImageBody({
    VoidCallback onPressed,
    ImageBonfire bonfire,
    Widget loading,
    Key key,
  })  : _onPressed = onPressed,
        _bonfire = bonfire,
        _loading = loading,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_bonfire.description != null && _bonfire.description.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: BonfireDescription(description: _bonfire.description),
          )
        else
          Container(),
        Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: BonfireImage(
                  imageUrl: _bonfire.imageUrl, onPressed: _onPressed),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _loading,
              ),
            ),
          ],
        )
      ],
    );
  }
}
