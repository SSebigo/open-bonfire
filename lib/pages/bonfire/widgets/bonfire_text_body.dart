import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_description.dart';
import 'package:flutter/material.dart';

class BonfireTextBody extends StatelessWidget {
  final TextBonfire _bonfire;

  const BonfireTextBody({TextBonfire bonfire, Key key})
      : _bonfire = bonfire,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: BonfireDescription(description: _bonfire.text),
    );
  }
}
