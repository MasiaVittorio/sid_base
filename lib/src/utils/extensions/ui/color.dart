import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

extension ColorTones on Color {
  // 0 = black / 100 = white
  Color withTone(int tone) {
    final h = Hct.fromInt(value);
    final palette = TonalPalette.of(h.hue, h.chroma);
    return Color(palette.get(tone.clamp(0, 100)));
  }

  Color withChroma(double chroma) {
    Hct h = Hct.fromInt(value);
    h.chroma = chroma;
    final palette = TonalPalette.of(h.hue, h.chroma);
    return Color(palette.get(h.tone.round().clamp(0, 100)));
  }
}

extension ColorSid on Color {
  Brightness get brightness => ThemeData.estimateBrightnessForColor(this);
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => !isDark;
  Color get contrast => isDark ? Colors.white : Colors.black;

  bool sameBrightnessAs(Color other) => brightness == other.brightness;
  bool notLegibleOn(Color other) => sameBrightnessAs(other);
  bool legibleOn(Color other) => !notLegibleOn(other);
}
