import 'package:flutter/material.dart';

class ColorManipulation {
  Color originalColor;
  Color _color;

  ColorManipulation(Color color) {
    originalColor =
        Color.fromARGB(color.alpha, color.red, color.green, color.blue);
    _color =
        Color.fromARGB(color.alpha, color.red, color.green, color.blue);
  }

  bool isDark() {
    return getBrightness() < 128.0;
  }

  bool isLight() {
    return !isDark();
  }

  double getBrightness() {
    return (_color.red * 299 + _color.green * 587 + _color.blue * 114) / 1000;
  }
}
