import 'package:bonfire/utils/palettes.dart';
import 'package:bonfire/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonfireDialog extends StatelessWidget {
  final String _title;
  final RichText _description;
  final String _titleButton1;
  final VoidCallback _onPressedButton1;
  final String _titleButton2;
  final VoidCallback _onPressedButton2;
  final double _width;
  final double _height;

  const BonfireDialog({
    Key key,
    @required String title,
    RichText description,
    @required String titleButton1,
    @required VoidCallback onPressedButton1,
    @required String titleButton2,
    @required VoidCallback onPressedButton2,
    double width,
    double height,
  })  : _title = title,
        _description = description,
        _titleButton1 = titleButton1,
        _onPressedButton1 = onPressedButton1,
        _titleButton2 = titleButton2,
        _onPressedButton2 = onPressedButton2,
        _width = width,
        _height = height,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Stack(
          children: <Widget>[
            // NOTE title
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            // NOTE description
            if (_description != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: _description,
              )
            else
              Container(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Button(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  height: 35.0,
                  onPressed: _onPressedButton1,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                  text: _titleButton1,
                  textColor: Theme.of(context).accentColor,
                  width: 75.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Button(
                  color: PaletteOne.colorOne,
                  fontWeight: FontWeight.bold,
                  height: 35.0,
                  onPressed: _onPressedButton2,
                  shape: const StadiumBorder(),
                  text: _titleButton2,
                  textColor: Colors.black,
                  width: 75.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
