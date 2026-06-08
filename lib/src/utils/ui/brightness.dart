import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension BrightnessSid on Brightness {
  String get name => switch (this) {
    Brightness.light => 'Light',
    Brightness.dark => 'Dark',
  };

  IconData get icon => switch (this) {
    Brightness.light => MdiIcons.weatherSunny,
    Brightness.dark => MdiIcons.weatherNight,
  };

  Color get contrast => switch (this) {
    Brightness.light => Colors.black,
    Brightness.dark => Colors.white,
  };

  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => switch (this) {
    Brightness.light => Brightness.dark,
    Brightness.dark => Brightness.light,
  };
}
