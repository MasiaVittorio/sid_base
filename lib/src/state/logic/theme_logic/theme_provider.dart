import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ThemeLogicProvider<T extends ThemeLogicBase> extends StatefulWidget {
  const ThemeLogicProvider({
    super.key,
    required this.createThemeLogic,
    this.child,
    required this.builder,
  });

  final T Function() createThemeLogic;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData darkTheme,
    ThemeMode themeMode,
    Widget? child,
  )
  builder;

  @override
  State<ThemeLogicProvider<T>> createState() => _ThemeLogicProviderState<T>();
}

class _ThemeLogicProviderState<T extends ThemeLogicBase>
    extends State<ThemeLogicProvider<T>> {
  late T logic;

  @override
  void initState() {
    super.initState();
    logic = widget.createThemeLogic();
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CleanProvider<T>(
      data: logic,
      child: logic.buildWithUsableTheme(
        builder: (context, lightTheme, darkTheme, themeMode) {
          return widget.builder(
            context,
            lightTheme,
            darkTheme,
            themeMode,
            widget.child,
          );
        },
      ),
    );
  }
}
