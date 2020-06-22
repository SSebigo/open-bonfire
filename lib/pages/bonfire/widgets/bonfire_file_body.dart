import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/pages/bonfire/widgets/bonfire_description.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireFileBody extends StatelessWidget {
  final VoidCallback onLongPress;
  final FileBonfire bonfire;

  const BonfireFileBody({Key key, this.onLongPress, this.bonfire})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (bonfire.description != null && bonfire.description.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: BonfireDescription(description: bonfire.description),
          )
        else
          Container(),
        ListTile(
          leading: Icon(
            Icons.insert_drive_file,
            size: 30.0,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            bonfire.fileName,
            style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20.0,
              ),
            ),
          ),
          onLongPress: onLongPress,
        )
      ],
    );
  }
}
