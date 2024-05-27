part of 'radio_slider.dart';

class RadioSliderThemeData {
  Color? selectedColor;
  Color? backgroundColor;
  bool hideOpenIcons;
  double height;
  EdgeInsets margin;
  bool elevateSlider;
  RadioSliderThemeData({
    this.elevateSlider = RadioSlider._kElevateSlider,
    this.selectedColor,
    this.backgroundColor,
    this.hideOpenIcons = false,
    this.height = RadioSlider._kHeight,
    this.margin = RadioSlider._kMargin,
  });

  RadioSliderThemeData mergeWith(RadioSliderThemeData other) => RadioSliderThemeData(
        elevateSlider: other.elevateSlider,
        selectedColor: other.selectedColor ?? selectedColor,
        backgroundColor: other.backgroundColor ?? backgroundColor,
        hideOpenIcons: other.hideOpenIcons,
        height: other.height,
        margin: other.margin,
      );
}

class RadioSliderTheme extends StatefulWidget {
  const RadioSliderTheme({
    super.key,
    required this.child,
    required this.data,
  });

  final Widget child;
  final RadioSliderThemeData data;

  @override
  State<RadioSliderTheme> createState() => _RadioSliderThemeState();

  static RadioSliderThemeData? of(BuildContext context) {
    _RadioSliderThemeInherited? provider = context
        .getElementForInheritedWidgetOfExactType<_RadioSliderThemeInherited>()
        ?.widget as _RadioSliderThemeInherited?;
    return provider?.data;
  }

  static Widget merge({
    required RadioSliderThemeData data,
    required Widget child,
  }) =>
      Builder(
        builder: (context) => RadioSliderTheme(
          data: RadioSliderTheme.of(context)?.mergeWith(data) ?? data,
          child: child,
        ),
      );
}

class _RadioSliderThemeState extends State<RadioSliderTheme> {
  @override
  Widget build(BuildContext context) {
    return _RadioSliderThemeInherited(
      data: widget.data,
      child: widget.child,
    );
  }
}

class _RadioSliderThemeInherited extends InheritedWidget {
  const _RadioSliderThemeInherited({
    required super.child,
    required this.data,
  });

  final RadioSliderThemeData data;

  @override
  bool updateShouldNotify(_RadioSliderThemeInherited oldWidget) => false;
}
