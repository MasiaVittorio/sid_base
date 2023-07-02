import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ThemeLogic extends LogicBase {
  
 @override
  void dispose() {
    dark.dispose();
  }

  static const int dataOverwrite = 1;

  late final PersistentReactive<bool> dark;

  final String keyBase;
  
  ThemeLogic({
    bool initialDark = true,
    this.keyBase = "theme logic", 
  }): dark = PersistentReactive<bool>(
    initialDark,
    key: "$keyBase $dataOverwrite relable var: dark",
  );

  ThemeData _baseThemeFromDark(bool dark){
    final scheme = !dark ? _lightColorScheme : _darkColorScheme;
    final base = ThemeData(
      fontFamily: "PlusJakartaSans",
      highlightColor: Colors.transparent,
      splashFactory: InkRipple.splashFactory,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      useMaterial3: true,
      applyElevationOverlayColor: true,
      scaffoldBackgroundColor: scheme.surface, 
    );
    return base.copyWith(splashFactory: InkSparkle.splashFactory);
  }

  Widget buildWithUsableTheme({
    required Widget Function(BuildContext context, ThemeData theme) builder,
  }) => dark.build((context, dark) => DynamicColorBuilder(
    builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      late final ColorScheme? scheme;
      final baseTheme = _baseThemeFromDark(dark);
      
      if(dark){
        if(darkDynamic != null){
          final b = darkDynamic.background.withTone(07);
          scheme = darkDynamic.copyWith(
            background: b,
            surface: b,
          );
        } else {
          scheme = null;
        }
      } else {
        scheme = lightDynamic;
      }

      late ThemeData usable; 
      if(scheme == null){
        usable = baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            background: baseTheme.brightness.isDark 
              ? ThemeLogic._customDarkBackground
              : Colors.white,
          ),
          dividerTheme: baseTheme.dividerTheme.copyWith(
            indent: 16, endIndent: 16, thickness: 0.8, 
            color: baseTheme.colorScheme.onSurface.withOpacity(0.35), 
          ),
        );
      } else {
        usable = baseTheme.copyWith(
          colorScheme: scheme,
          canvasColor: scheme.background,
          dividerTheme: baseTheme.dividerTheme.copyWith(
            indent: 16, endIndent: 16, thickness: 0.8, 
            color: scheme.onSurface.withOpacity(0.35), 
          ),
        );
      }

      usable = usable.copyWith(
        scaffoldBackgroundColor: usable.colorScheme.surface
      );

      return Builder(builder: (context) => builder(context, usable),);
    },
  ),);

  void toggleBrightness() => dark.update(!dark.value);



  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF496800),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFC5F272),
    onPrimaryContainer: Color(0xFF131F00),
    secondary: Color(0xFF596248),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDDE6C6),
    onSecondaryContainer: Color(0xFF171E0A),
    tertiary: Color(0xFF396661),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBCECE5),
    onTertiaryContainer: Color(0xFF00201D),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFEFCF4),
    onBackground: Color(0xFF1B1C17),
    surface: Color(0xFFFEFCF4),
    onSurface: Color(0xFF1B1C17),
    surfaceVariant: Color(0xFFE2E4D4),
    onSurfaceVariant: Color(0xFF45483D),
    outline: Color(0xFF75786B),
    onInverseSurface: Color(0xFFF2F1E9),
    inverseSurface: Color(0xFF30312C),
    inversePrimary: Color(0xFFAAD559),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF496800),
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFAAD559),
    onPrimary: Color(0xFF243600),
    primaryContainer: Color(0xFF364E00),
    onPrimaryContainer: Color(0xFFC5F272),
    secondary: Color(0xFFC1CAAB),
    onSecondary: Color(0xFF2C331D),
    secondaryContainer: Color(0xFF424A32),
    onSecondaryContainer: Color(0xFFDDE6C6),
    tertiary: Color(0xFFA0D0C9),
    onTertiary: Color(0xFF013733),
    tertiaryContainer: Color(0xFF1F4E49),
    onTertiaryContainer: Color(0xFFBCECE5),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: _customDarkBackground,
    onBackground: Color(0xFFE4E3DB),
    surface: _customDarkBackground,
    onSurface: Color(0xFFE4E3DB),
    surfaceVariant: Color(0xFF45483D),
    onSurfaceVariant: Color(0xFFC6C8B9),
    outline: Color(0xFF8F9284),
    onInverseSurface: Color(0xFF1B1C17),
    inverseSurface: Color(0xFFE4E3DB),
    inversePrimary: Color(0xFF496800),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFAAD559),
  );
  
  static const _customDarkBackground = Color(0xff171717);
}