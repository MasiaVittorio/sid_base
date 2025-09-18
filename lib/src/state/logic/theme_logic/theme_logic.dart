import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/state/logic/theme_logic/custom_scheme.dart';

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
  late final PersistentReactive<CustomScheme> customScheme;

  CustomScheme get defaultCustomScheme => CustomScheme(
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    contrastLevel: 0,
    seedColor: const Color.fromARGB(255, 179, 140, 223),
  );

  void resetToDefaultCustomScheme() => customScheme.update(defaultCustomScheme);

  void toggleUseDynamic() => useDynamic.update(!useDynamic.value);

  ThemeLogicBase({
    ThemeMode initialThemeMode = ThemeMode.system,
    bool initialUseDynamic = true,
    this.keyBase = "new theme logic",
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
    customScheme = PersistentReactive(
      defaultCustomScheme,
      key: "$keyBase $dataOverwrite persistent var: customScheme",
      toJsonEncodable: (value) => value.toMap(),
      fromJsonDecoded: (jsonDecoded) => CustomScheme.fromMap(jsonDecoded),
    );
  }

  int get dataOverwrite => 4;

  String get defaultFontFamily => "Roboto";
  String? get displayFontFamily => null;
  String? get headlineFontFamily => null;
  String? get titleFontFamily => null;
  String? get bodyFontFamily => null;
  String? get labelFontFamily => null;

  ThemeData _baseThemeFromCustom(
    CustomScheme customScheme,
    Brightness brightness,
  ) => _baseThemeFromScheme(customScheme.getScheme(brightness), brightness);

  ThemeData _baseThemeFromScheme(ColorScheme scheme, Brightness brightness) {
    return _fixTransitions(
      ThemeData.from(
        colorScheme: scheme,
        useMaterial3: true,
        textTheme:
            ThemeData(
              fontFamily: defaultFontFamily,
              colorScheme: scheme,
              useMaterial3: true,
            ).textTheme,
      ),
    );
  }

  ThemeData _fixTransitions(ThemeData theme) => theme.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
  );

  ThemeData _applyFamilies(ThemeData theme) => theme.applyFamilies(
    display: displayFontFamily,
    headline: headlineFontFamily,
    title: titleFontFamily,
    body: bodyFontFamily,
    label: labelFontFamily,
  );

  Widget buildWithUsableTheme({
    required Widget Function(
      BuildContext context,
      ThemeData lightTheme,
      ThemeData darkTheme,
      ThemeMode themeMode,
    )
    builder,
  }) {
    return Reactive.build3(
      themeMode,
      useDynamic,
      customScheme,
      builder: (_, mode, dynamic, customSchemeValue) {
        return MyDynamicThemeBuilder(
          builder: (context, dynamicSeed) {
            final ThemeData light = applyAppCustomizations(
              _applyFamilies(
                _baseThemeFromCustom(
                  customSchemeValue.copyWith(
                    seedColor:
                        dynamic && dynamicSeed != null ? dynamicSeed : null,
                  ),
                  Brightness.light,
                ),
              ),
            );
            final ThemeData dark = applyAppCustomizations(
              _applyFamilies(
                _baseThemeFromCustom(
                  customSchemeValue.copyWith(
                    seedColor:
                        dynamic && dynamicSeed != null ? dynamicSeed : null,
                  ),
                  Brightness.dark,
                ),
              ),
            );

            return Builder(
              builder: (context) => builder(context, light, dark, mode),
            );
          },
        );
      },
    );
  }

  /// override this to apply yout theme extensions and such,
  /// this is the last edit that is made to the theme before being passed to the builder
  ThemeData applyAppCustomizations(ThemeData theme) {
    return theme;
  }
}

extension on ThemeData {
  ThemeData applyFamilies({
    String? display,
    String? headline,
    String? title,
    String? body,
    String? label,
  }) {
    return copyWith(
      textTheme: textTheme.withFamilies(
        display: display,
        headline: headline,
        title: title,
        body: body,
        label: label,
      ),
    );
  }
}

class MyDynamicThemeBuilder extends StatefulWidget {
  const MyDynamicThemeBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, Color? seed) builder;

  @override
  State<MyDynamicThemeBuilder> createState() => _MyDynamicThemeBuilderState();
}

class _MyDynamicThemeBuilderState extends State<MyDynamicThemeBuilder> {
  Color? seed;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      if (corePalette != null) {
        debugPrint('dynamic_color: Core palette detected.');
        setState(() {
          seed = Color(corePalette.primary.get(70));
        });
        return;
      }
    } on PlatformException {
      debugPrint('dynamic_color: Failed to obtain core palette.');
    }

    try {
      final Color? accentColor = await DynamicColorPlugin.getAccentColor();

      // Likewise above.
      if (!mounted) return;

      if (accentColor != null) {
        debugPrint('dynamic_color: Accent color detected.');
        setState(() {
          seed = accentColor;
        });
        return;
      }
    } on PlatformException {
      debugPrint('dynamic_color: Failed to obtain accent color.');
    }

    debugPrint('dynamic_color: Dynamic color not detected on this device.');
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, seed);
  }
}
