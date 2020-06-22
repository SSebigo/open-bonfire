import 'package:bonfire/utils/palettes.dart';
import 'package:flutter/material.dart';

mixin Themes {
  static final ThemeData light = ThemeData(
    accentColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    buttonColor: Colors.black26,
    backgroundColor: const Color(0xffefeeee),
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData(
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: PaletteOne.colorFive,
    ),
    buttonColor: Colors.white70,
    backgroundColor: Colors.black45,
    primaryColor: PaletteOne.colorFive,
    scaffoldBackgroundColor: PaletteOne.colorFive,
  );
}