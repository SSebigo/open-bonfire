import 'dart:math';

import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/caesar_cipher.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireDescription extends StatefulWidget {
  final String _description;

  const BonfireDescription({
    @required String description,
    Key key,
  })  : _description = description,
        super(key: key);

  @override
  _BonfireDescriptionState createState() => _BonfireDescriptionState();
}

class _BonfireDescriptionState extends State<BonfireDescription> {
  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  String _penaltyUniqueName;

  @override
  void initState() {
    _penaltyUniqueName = _localStorageRepository
        ?.getPenaltyData(Constants.penaltyUniqueName) as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_penaltyUniqueName) {
      case 'mirror':
        return Container(
          width: double.infinity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: SelectableText(
              widget._description,
              style: GoogleFonts.varelaRound(
                textStyle: TextStyle(
                  fontSize: 22.5,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        );
        break;
      case 'upside_down':
        return Container(
          width: double.infinity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(pi),
            child: SelectableText(
              widget._description,
              style: GoogleFonts.varelaRound(
                textStyle: TextStyle(
                  fontSize: 22.5,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        );
        break;
      case 'caesar_cipher':
        final Caesar caesarCipher = Caesar(3);
        return Container(
          width: double.infinity,
          child: SelectableText(
            caesarCipher.encrypt(widget._description),
            style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                fontSize: 22.5,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        );
        break;
      default:
        return Container(
          width: double.infinity,
          child: Text(
            widget._description,
            style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                fontSize: 22.5,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        );
    }
  }
}
