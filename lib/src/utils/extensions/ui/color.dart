import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

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
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => !isDark;
  Color get contrast => isDark ? Colors.white : Colors.black;

  bool sameBrightnessAs(Color other) => brightness == other.brightness;
  bool notLegibleOn(Color other) => sameBrightnessAs(other);
  bool legibleOn(Color other) => !notLegibleOn(other);
}

extension RightContrastFromTheme on ThemeData {
  RightContrast rightContrast({
    bool fallbackOnTextTheme = false,
    bool fallbackOnIconTheme = false,
  }) => RightContrast(
    this,
    fallbackOnIconTheme: fallbackOnIconTheme,
    fallbackOnTextTheme: fallbackOnTextTheme,
  );
}

class RightContrast {
  final ThemeData theme;
  final bool fallbackOnTextTheme;
  final bool fallbackOnIconTheme;

  const RightContrast(
    this.theme, {
    this.fallbackOnIconTheme = false,
    this.fallbackOnTextTheme = false,
  }) : assert(!(fallbackOnIconTheme && fallbackOnTextTheme));

  Color get onCanvas {
    final Color accent = theme.colorScheme.secondary;
    final Color primary = theme.primaryColor;
    final Color canvas = theme.canvasColor;

    if (primary.legibleOn(canvas)) {
      return primary;
    } else if (accent.legibleOn(canvas)) {
      return accent;
    }

    if (fallbackOnIconTheme) {
      Color? res = theme.iconTheme.color;
      if (res != null) return res;
    }

    if (fallbackOnTextTheme) {
      Color? res = theme.textTheme.bodyMedium?.color;
      if (res != null) return res;
    }

    return canvas.contrast;
  }

  Color get onAccent {
    final Color primary = theme.primaryColor;
    final Color accent = theme.colorScheme.secondary;

    if (accent.legibleOn(primary)) return primary;

    if (fallbackOnIconTheme || fallbackOnTextTheme) {
      final Color res = theme.colorScheme.onSecondary;
      return res;
    }

    return accent.contrast;
  }

  Color get onPrimary {
    final Color accent = theme.colorScheme.secondary;
    final Color primary = theme.primaryColor;

    if (accent.legibleOn(primary)) return accent;

    if (fallbackOnIconTheme) {
      final Color? res = theme.primaryIconTheme.color;
      if (res != null) return res;
    }
    if (fallbackOnTextTheme) {
      final Color? res = theme.primaryTextTheme.bodyMedium?.color;
      if (res != null) return res;
    }

    return primary.contrast;
  }

  Color onColor(Color color) {
    final Color accent = theme.colorScheme.secondary;
    final Color primary = theme.primaryColor;

    if (primary.legibleOn(color)) {
      return primary;
    } else if (accent.legibleOn(color)) {
      return accent;
    }

    return color.contrast;
  }
}
