import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef StringToVoidFunction = void Function(String);

class BonfireTextField extends StatelessWidget {
  final StringToVoidFunction _onChanged;
  final String _hintText;

  const BonfireTextField({
    Key key,
    StringToVoidFunction onChanged,
    String hintText,
  })  : _onChanged = onChanged,
        _hintText = hintText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20.0,
        ),
      ),
      decoration: InputDecoration(
        hintText: _hintText,
        hintStyle: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      onChanged: _onChanged,
    );
  }
}
