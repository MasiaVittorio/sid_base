import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HomeExample extends StatelessWidget {

  const HomeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = CleanProvider.of<ThemeLogic>(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        themeLogic.dark.build((context, value) => SwitchListTile(
          value: value, 
          onChanged: (_) => themeLogic.toggleBrightness(),
          title: const Text("Dark mode:"),
          secondary: Icon(MdiIcons.weatherNight),
        )),
      ],),
    );
  }
}