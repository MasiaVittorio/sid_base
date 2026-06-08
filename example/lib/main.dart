import 'dart:ui';

import 'package:example/logic/theme_logic.dart';
import 'package:example/widgets/centered_carousel.dart';
import 'package:example/widgets/hero_carousel_home.dart';
import 'package:example/widgets/multi_browse_carousel_home.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

void main() {
  runApp(const AppExample());
}

class AppExample extends StatefulWidget {
  const AppExample({super.key});

  @override
  State<AppExample> createState() => _AppExampleState();
}

class _AppExampleState extends State<AppExample> {
  late ThemeLogic themeLogic;

  @override
  void initState() {
    super.initState();
    themeLogic = ThemeLogic();
  }

  @override
  void dispose() {
    themeLogic.dispose();
    const HivePersistence().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CleanProvider(
      data: themeLogic,
      child: themeLogic.buildWithUsableTheme(
        builder: (BuildContext context, ThemeData theme) {
          return MaterialApp(
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            title: 'Example',
            theme: theme,
            home: Scaffold(
              appBar: AppBar(title: const Text("Carousel examples")),
              body: Builder(builder: (context) {
                return ListView(
                  children: [
                    themeLogic.dark.build(
                      (context, value) => SwitchListTile(
                        value: value,
                        onChanged: (_) => themeLogic.toggleBrightness(),
                        title: const Text("Dark mode:"),
                        secondary: Icon(MdiIcons.weatherNight),
                      ),
                    ),
                    ListTile(
                      title: const Text("Multi-Browse Carousel"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () => context.pushPage(const MultiBrowseCarouselHome()),
                    ),
                    ListTile(
                      title: const Text("Centered Hero Carousel"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () => context.pushPage(const CenteredCarouselHome()),
                    ),
                    ListTile(
                      title: const Text("Hero Carousel"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () => context.pushPage(const HeroCarouselHome()),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
