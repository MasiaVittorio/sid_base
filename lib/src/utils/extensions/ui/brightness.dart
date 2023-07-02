import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension BrightnessSid on Brightness {
  String get name => _Brightness.names[this]!;

  IconData get icon => _Brightness.icons[this]!;

  Color get contrast => isLight ? Colors.black : Colors.white;

  bool get isLight => this == Brightness.light;
  bool get isDark => !isLight;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}


class _Brightness {
  static const Map<Brightness, String> names = <Brightness,String>{
    Brightness.dark: "Dark",
    Brightness.light: "Light",
  };

  // static const Map<String,Brightness> invertedNames = <String,Brightness>{
  //   "Light": Brightness.light,
  //   "Dark": Brightness.dark,
  // };
  // static Brightness fromName(String name) => invertedNames[name];

  static final Map<Brightness,IconData> icons = <Brightness,IconData>{
    Brightness.light: MdiIcons.weatherSunny,
    Brightness.dark: MdiIcons.weatherNight,
  };
}