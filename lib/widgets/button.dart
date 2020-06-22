import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final Color _color, _textColor;
  final double _elevation, _fontSize, _height, _width;
  final FontWeight _fontWeight;
  final ShapeBorder _shape;
  final String _text;
  final VoidCallback _onPressed;

  const Button({
    Color color,
    Color textColor,
    double elevation,
    double fontSize,
    @required double height,
    @required double width,
    FontWeight fontWeight,
    ShapeBorder shape,
    String text,
    VoidCallback onPressed,
    Key key,
  })  : _color = color,
        _elevation = elevation,
        _fontSize = fontSize,
        _fontWeight = fontWeight,
        _height = height,
        _onPressed = onPressed,
        _shape = shape,
        _textColor = textColor,
        _text = text,
        _width = width,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: _color,
      disabledColor: Colors.black12,
      disabledTextColor: Colors.grey,
      elevation: _elevation ?? 2.0,
      height: _height,
      highlightColor: Colors.transparent,
      highlightElevation: 0.0,
      minWidth: _width,
      onPressed: _onPressed,
      shape: _shape,
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: _onPressed == null ? Colors.grey : _textColor,
            fontSize: _fontSize,
            fontWeight: _fontWeight,
          ),
        ),
      ),
    );
  }
}
