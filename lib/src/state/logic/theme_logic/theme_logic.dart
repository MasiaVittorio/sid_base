import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

abstract class ThemeLogicBase extends LogicBase {
  @mustCallSuper
  @override
  void dispose() {
    themeMode.dispose();
    useDynamic.dispose();
    super.dispose();
  }

  final String keyBase;
  late final PersistentReactive<ThemeMode> themeMode;
  late final PersistentReactive<bool> useDynamic;

  void toggleUseDynamic() => useDynamic.update(!useDynamic.value);

  ThemeLogicBase({
    ThemeMode initialThemeMode = ThemeMode.system,
    bool initialUseDynamic = true,
    this.keyBase = "theme logic",
  }) {
    themeMode = PersistentReactive(
      initialThemeMode,
      key: "$keyBase $dataOverwrite relable var: dark",
      fromJsonDecoded: (index) => ThemeMode.values[index],
      toJsonEncodable: (themeModeValue) => themeModeValue.index,
    );
    useDynamic = initialUseDynamic.createPersistentReactive(
      key: "$keyBase $dataOverwrite persistent var: useDynamicColors",
    );
  }

  int get dataOverwrite => 1;

  String get defaultFontFamily => "Roboto";
  String? get displayFontFamily => null;
  String? get headlineFontFamily => null;
  String? get titleFontFamily => null;
  String? get bodyFontFamily => null;
  String? get labelFontFamily => null;

  ColorScheme get defaultLightScheme;
  ColorScheme get defaultDarkScheme;

  ThemeData _baseThemeFromDark(bool dark) {
    final scheme = !dark ? defaultLightScheme : defaultDarkScheme;
    final base = ThemeData(
        fontFamily: defaultFontFamily,
        highlightColor: Colors.transparent,
        splashFactory: InkRipple.splashFactory,
        brightness: dark ? Brightness.dark : Brightness.light,
        colorScheme: scheme,
        useMaterial3: true,
        applyElevationOverlayColor: true,
        scaffoldBackgroundColor: scheme.surface,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowEnterRouteSnapshotting: false,
          ),
        }));
    return base.copyWith(splashFactory: InkSparkle.splashFactory);
  }

  Color get customDarkBackground => const Color(0xff171717);

  Widget buildWithUsableTheme({
    required Widget Function(
      BuildContext context,
      ThemeData lightTheme,
      ThemeData darkTheme,
      ThemeMode themeMode,
    ) builder,
  }) {
    return Reactive.build2(themeMode, useDynamic, builder: (_, themeModeValue, useDynamic) {
      return DynamicColorBuilder(builder: (ColorScheme? lD, ColorScheme? dD) {
        ColorScheme? lightScheme;
        ColorScheme? darkScheme;

        if (useDynamic) {
          if (dD != null) {
            final b = customDarkBackground;
            darkScheme = dD.copyWith(
              surface: b,
            );
          } else {
            darkScheme = null;
          }
          lightScheme = lD;
        }

        final baseLightTheme = _baseThemeFromDark(false);
        final baseDarkTheme = _baseThemeFromDark(true);

        ThemeData usableLight = _applyDynamicSchemeAndBaseCustomizations(baseLightTheme, lightScheme);
        ThemeData usableDark = _applyDynamicSchemeAndBaseCustomizations(baseDarkTheme, darkScheme);

        usableLight = usableLight.copyWith(
          scaffoldBackgroundColor: usableLight.colorScheme.surface,
        );
        usableDark = usableDark.copyWith(
          scaffoldBackgroundColor: usableDark.colorScheme.surface,
        );

        usableLight = usableLight.copyWith(
          textTheme: usableLight.textTheme.withFamilies(
            display: displayFontFamily,
            headline: headlineFontFamily,
            title: titleFontFamily,
            body: bodyFontFamily,
            label: labelFontFamily,
          ),
        );
        usableDark = usableDark.copyWith(
          textTheme: usableDark.textTheme.withFamilies(
            display: displayFontFamily,
            headline: headlineFontFamily,
            title: titleFontFamily,
            body: bodyFontFamily,
            label: labelFontFamily,
          ),
        );

        usableLight = applyAppCustomizations(usableLight);
        usableDark = applyAppCustomizations(usableDark);

        return Builder(
          builder: (context) => builder(
            context,
            usableLight,
            usableDark,
            themeModeValue,
          ),
        );
      });
    });
  }

  /// override this to apply yout theme extensions and such, 
  /// this is the last edit that is made to the theme before being passed to the builder
  ThemeData applyAppCustomizations(ThemeData theme) {
    return theme;
  }

  ThemeData _applyDynamicSchemeAndBaseCustomizations(ThemeData baseTheme, ColorScheme? scheme) {
    return switch (scheme) {
      null => baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            surface: switch (baseTheme.brightness) {
              Brightness.dark => customDarkBackground,
              Brightness.light => Colors.white,
            },
          ),
          canvasColor: switch (baseTheme.brightness) {
            Brightness.dark => customDarkBackground,
            Brightness.light => Colors.white,
          },
          dividerTheme: _dividerTheme(baseTheme, baseTheme.colorScheme),
        ),
      ColorScheme scheme => baseTheme.copyWith(
          colorScheme: scheme,
          canvasColor: scheme.surface,
          dividerTheme: _dividerTheme(baseTheme, scheme),
        ),
    };
  }

  double get dividerIndent => 16;
  double get dividerEndIndent => 16;
  double get dividerThickness => 0.8;
  Color dividerColor(ColorScheme scheme) => scheme.onSurface.withOpacity(0.35);
  DividerThemeData _dividerTheme(ThemeData baseTheme, ColorScheme scheme) =>
      baseTheme.dividerTheme.copyWith(
        indent: dividerIndent,
        endIndent: dividerEndIndent,
        thickness: dividerThickness,
        color: dividerColor(scheme),
      );
}
