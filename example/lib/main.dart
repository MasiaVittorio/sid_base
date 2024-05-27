import 'package:example/logic/theme_logic.dart';
import 'package:example/widgets/carousel_home.dart';
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
            title: 'Example',
            theme: theme,
            home: const CarouselHome(),
          );
        },
      ),
    );
  }
}
