import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef StringToVoidFunction = String Function(String);

class BonfireTextFormField extends StatelessWidget {
  final StringToVoidFunction _onChanged;
  final StringToVoidFunction _validator;
  final TextEditingController _controller;
  final String _initialValue;
  final TextInputType _keyboardType;
  final bool _obscureText;
  final bool _autocorrect;
  final bool _enableSuggestions;
  final String _labelText;
  final String _hintText;
  final Widget _prefixIcon;
  final int _errorMaxLines;

  const BonfireTextFormField({
    Key key,
    StringToVoidFunction onChanged,
    StringToVoidFunction validator,
    TextEditingController controller,
    String initialValue,
    TextInputType keyboardType,
    bool obscureText = false,
    bool autocorrect = false,
    bool enableSuggestions = false,
    String labelText,
    String hintText,
    Widget prefixIcon,
    int errorMaxLines = 3,
  })  : _onChanged = onChanged,
        _validator = validator,
        _controller = controller,
        _initialValue = initialValue,
        _keyboardType = keyboardType,
        _obscureText = obscureText,
        _autocorrect = autocorrect,
        _enableSuggestions = enableSuggestions,
        _labelText = labelText,
        _hintText = hintText,
        _prefixIcon = prefixIcon,
        _errorMaxLines = errorMaxLines,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      initialValue: _initialValue,
      keyboardType: _keyboardType,
      style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      decoration: InputDecoration(
        errorMaxLines: _errorMaxLines,
        prefixIcon: _prefixIcon,
        labelText: _labelText,
        labelStyle: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        hintText: _hintText,
        hintStyle: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.0,
            color: Theme.of(context).backgroundColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      autovalidate: true,
      autocorrect: _autocorrect,
      enableSuggestions: _enableSuggestions,
      obscureText: _obscureText,
      onChanged: _onChanged,
      validator: _validator,
    );
  }
}
