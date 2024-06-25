import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

import 'components/simple_nav_bar.dart';

enum ColorPickerMode {
  palette,
  manual,
  custom,
}

class MaterialColorPicker extends StatefulWidget {
  final Color color;
  final Function(Color?) onSubmitted;

  final void Function()? underscrollCallback;

  final Widget Function({
    required BuildContext context,
    void Function(ColorPickerMode)? toggleMode,
    void Function()? onSubmitted,
    ColorPickerMode? currentMode,
    Color? currentColor,
    Color? currentContrast,
  })? navigatorAndSaveBuilder;

  const MaterialColorPicker({
    super.key,
    required this.color,
    required this.onSubmitted,
    this.navigatorAndSaveBuilder,
    this.underscrollCallback,
  });

  @override
  State createState() => _MaterialColorPickerState();
}

class _MaterialColorPickerState extends State<MaterialColorPicker> with TickerProviderStateMixin {
  Color? _color;
  ColorPickerMode? _mode = ColorPickerMode.custom;
  late final Widget Function({
    required BuildContext context,
    void Function(ColorPickerMode?)? toggleMode,
    void Function()? onSubmitted,
    ColorPickerMode? currentMode,
    Color? currentColor,
    Color? currentContrast,
  })? _navigatorAndSaveBuilder;

  @override
  void initState() {
    super.initState();

    if (widget.navigatorAndSaveBuilder == null) {
      _navigatorAndSaveBuilder = defaultNavigatorAndSaveBuilder;
    } else {
      _navigatorAndSaveBuilder = widget.navigatorAndSaveBuilder;
    }

    _color = widget.color;

    if (PaletteTab.allColors.contains(_color)) {
      _mode = ColorPickerMode.palette;
    } else {
      _mode = ColorPickerMode.manual;
    }
  }

  void toggleMode(ColorPickerMode? newMode) => setState(() {
        _mode = newMode;
        if (_mode == ColorPickerMode.palette) {
          if (PaletteTab.allColors.contains(_color) == false) {
            _color = PaletteTab.findClosestMaterialColor(_color);
          }
        }
      });

  void onColor(Color? c) {
    setState(() {
      _color = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Widget divider = Divider(
      height: 0.0,
    );

    final Map<ColorPickerMode, Widget> child = {
      ColorPickerMode.manual: ManualColorPicker(
        onChanged: onColor,
        color: _color!,
      ),
      ColorPickerMode.custom: CustomColorPicker(
        displayerUndescrollCallback: widget.underscrollCallback,
        color: _color,
        onChanged: onColor,
      ),
      ColorPickerMode.palette: PaletteColorPicker(
        color: _color,
        onChanged: onColor,
        paletteUndescrollCallback: widget.underscrollCallback,
      ),
    };

    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              constraints: constraints,
              child: child[_mode!],
            );
          }),
        ),
        divider,
        _navigatorAndSaveBuilder!(
            context: context,
            toggleMode: (ColorPickerMode? cm) => toggleMode(cm),
            onSubmitted: () => widget.onSubmitted(_color),
            currentMode: _mode,
            currentColor: _color,
            currentContrast: ThemeData.estimateBrightnessForColor(_color!) == Brightness.dark
                ? Colors.white
                : Colors.black)
      ],
    );
  }
}

Widget defaultNavigatorAndSaveBuilder({
  required BuildContext context,
  void Function(ColorPickerMode?)? toggleMode,
  void Function()? onSubmitted,
  ColorPickerMode? currentMode,
  Color? currentColor,
  Color? currentContrast,
}) {
  Color iconColor = Theme.of(context).canvasColor.contrast;
  Color inactiveIconColor = iconColor.withOpacity(0.6);

  return Material(
    child: Row(
      children: <Widget>[
        Expanded(
            child: SimpleNavBar(
          currentIndex: {
            ColorPickerMode.manual: 0,
            ColorPickerMode.custom: 1,
            ColorPickerMode.palette: 2,
          }[currentMode!]!,
          onTap: (int i) {
            toggleMode!({
              0: ColorPickerMode.manual,
              1: ColorPickerMode.custom,
              2: ColorPickerMode.palette,
            }[i]);
          },
          items: <SimpleItem>[
            SimpleItem(
              color: iconColor,
              title: "Manual",
              icon: Icons.format_color_fill,
            ),
            SimpleItem(
              color: iconColor,
              title: "Custom",
              icon: Icons.short_text,
            ),
            SimpleItem(color: iconColor, title: "Palette", icon: Icons.palette),
          ],
          titleStyle: const TextStyle(fontWeight: FontWeight.w700),
          iconColor: iconColor,
          inactiveIconColor: inactiveIconColor,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
              onPressed: onSubmitted,
              backgroundColor: currentColor,
              child: Icon(
                Icons.save,
                color: currentContrast,
              )),
        ),
      ],
    ),
  );
}
