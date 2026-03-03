import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:sid_base/src/utils/ui/brightness.dart';

extension ColorTones on Color {
  // 0 = black / 100 = white
  Color withTone(int tone) {
    final h = Hct.fromInt(toARGB32());
    final palette = TonalPalette.of(h.hue, h.chroma);
    return Color(palette.get(tone.clamp(0, 100)));
  }

  double get tone {
    return Hct.fromInt(toARGB32()).tone;
  }

  double get chroma {
    return Hct.fromInt(toARGB32()).chroma;
  }

  double get hue {
    return Hct.fromInt(toARGB32()).hue;
  }

  Color withChroma(double chroma) {
    Hct h = Hct.fromInt(toARGB32());
    h.chroma = chroma;
    final palette = TonalPalette.of(h.hue, h.chroma);
    return Color(palette.get(h.tone.round().clamp(0, 100)));
  }
}

extension ColorSid on Color {
  Brightness get brightness => ThemeData.estimateBrightnessForColor(this);
  bool get isDark => brightness.isDark;
  bool get isLight => brightness.isLight;
  Color get contrast => brightness.contrast;

  bool sameBrightnessAs(Color other) => brightness == other.brightness;
  bool legibleOn(Color other) => brightness != other.brightness;
}
