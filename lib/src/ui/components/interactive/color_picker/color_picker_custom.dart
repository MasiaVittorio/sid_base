import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/ui/components/interactive/color_picker/components/advanced_slider/advanced_slider.dart';

class CustomColorPicker extends StatefulWidget {
  final Color? color;
  final void Function(Color?) onChanged;
  final void Function()? displayerUndescrollCallback;

  const CustomColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    required this.displayerUndescrollCallback,
  });

  static const double sliderHeight = 64;

  @override
  State createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> with TickerProviderStateMixin {
  Color? _color;
  bool? _rgbMode;

  late double _hue;
  late double _sat;
  late double _value;

  bool _insertMode = false; //wether youre inserting a text or not
  TextEditingController? _controller;
  // String _clipboardString;

  @override
  void initState() {
    super.initState();

    //Color stuff
    _rgbMode = true;
    _insertMode = false;
    _reset();

    //Insert stuff
    _insertMode = false;
    _controller = TextEditingController(
      text: (_color!.red.toRadixString(16).padLeft(2, '0') +
              _color!.green.toRadixString(16).padLeft(2, '0') +
              _color!.blue.toRadixString(16).padLeft(2, '0'))
          .toUpperCase(),
    );
  }

  void _reset() {
    _color = widget.color?.withAlpha(255) ?? Colors.black;
    _updateHsvFromColor();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (colorFromHsv != widget.color) {
      _reset();
    }
  }

  void switchMode() {
    setState(() {
      _rgbMode = _rgbMode == false;
    });
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _color!.hexString));
  }

  void _updateHsvFromColor() {
    final hsv = HSVColor.fromColor(_color!);

    _hue = hsv.hue;
    _sat = hsv.saturation;
    _value = hsv.value;
  }

  void _updateColorFromHsv() {
    _color = colorFromHsv;
  }

  Color get colorFromHsv => HSVColor.fromAHSV(
        _color!.alpha / 255.toDouble(),
        _hue,
        _sat,
        _value,
      ).toColor();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, externalConstraints) {
        final themeOfContext = Theme.of(context);
        final sliderThemeOfContext = SliderTheme.of(context);

        final bool big = CustomColorPicker.sliderHeight * 6 + 50 <= externalConstraints.maxHeight;

        final Color activeColor = themeOfContext.canvasColor.contrast;

        final List<Widget> rgbs = <Widget>[
          _rgbSlider("Red"),
          _rgbSlider("Green"),
          _rgbSlider("Blue"),
        ];

        final List<Widget> hsls = <Widget>[
          _hueSlider(activeColor, sliderThemeOfContext),
          _saturationSlider(activeColor, sliderThemeOfContext),
          _valueSlider(activeColor, sliderThemeOfContext),
        ];

        return Column(
          children: <Widget>[
            _displayer(big, themeOfContext),
            Shadowed(
              child: Column(
                children: <Widget>[
                  if (big || _rgbMode == true) ...rgbs,
                  if (big || _rgbMode == false) ...hsls,
                ],
              ),
            ),
          ],
        );
      });

  bool get _scrollable => widget.displayerUndescrollCallback != null;

  Widget _scrollableDisplayer(BoxConstraints constraints, bool big, ThemeData themeOfContext) =>
      Theme(
        data: themeOfContext.copyWith(
          colorScheme: themeOfContext.colorScheme.copyWith(
            secondary: _color == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        child: SingleChildScrollView(
            physics: CallbackScrollPhysics(
              alwaysScrollable: true,
              bottomBounce: false,
              topBounce: _scrollable,
              topBounceCallback: widget.displayerUndescrollCallback,
            ),
            child: _materialDisplayer(constraints, big)),
      );

  Widget _displayer(bool big, ThemeData themeOfContext) => _scrollable
      ? Expanded(
          child: LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: constraints,
            child: _scrollableDisplayer(constraints, big, themeOfContext),
          ),
        ))
      : Expanded(child: _materialDisplayer(null, big));

  final Map<String, Color> _baseColorMap = {
    "Red": Colors.red,
    "Blue": Colors.blue,
    "Green": Colors.green,
  };
  Widget _rgbSlider(String rgb) {
    final Color clr = _color!;

    int number = {
      "Red": clr.red,
      "Green": clr.green,
      "Blue": clr.blue,
    }[rgb]!;

    Color baseColor = _baseColorMap[rgb]!;

    return AdvancedSlider(
      height: CustomColorPicker.sliderHeight,
      name: '$rgb: $number',
      annotation: '(${number.toRadixString(16).padLeft(2, '0').toUpperCase()} hex)',
      value: number.toDouble(),
      activeColor: baseColor,
      inactiveColor: baseColor.withOpacity(0.24),
      max: 255.0,
      min: 0.0,
      onChanged: (double nd) {
        setState(() {
          if (rgb == "Red") _color = clr.withRed(nd.round());
          if (rgb == "Green") _color = clr.withGreen(nd.round());
          if (rgb == "Blue") _color = clr.withBlue(nd.round());
          _updateHsvFromColor();
          widget.onChanged(_color);
        });
      },
      buttonDivision: 1.0,
    );
  }

  Widget _materialDisplayer(BoxConstraints? constraints, bool big) {
    final bool darkBkg = ThemeData.estimateBrightnessForColor(_color!) == Brightness.dark;

    return Material(
      color: _color,
      child: Theme(
        data: darkBkg ? ThemeData.dark() : ThemeData.light(),
        child: constraints == null
            ? _center(big, darkBkg)
            : SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: _center(big, darkBkg)),
      ),
    );
  }

  Widget _center(bool big, bool darkBkg) => Row(
        children: <Widget>[
          Expanded(
            child: _insertMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _controller!.clear();
                      _insertMode = false;
                    }),
                  )
                : switcher(big),
          ),
          Expanded(child: _realCenter(darkBkg)),
          Expanded(
            child: _insertMode
                // ? IconButton(
                //   icon: const Icon(Icons.content_paste),
                //   onPressed: _clipboardString != null ? () async{
                //     await this._getClipboardAndCheck();

                //     if(this._clipboardString == null) return;

                //     setState(() {
                //       this._controller.text = this._clipboardString+'';
                //     });
                //   } : null
                // )
                ? InkWell(
                    onTap: confirmInsert,
                    child: const Center(
                      child: Icon(Icons.check),
                    ),
                  )
                : InkWell(
                    onTap: copyToClipboard,
                    child: const Center(
                      child: Icon(Icons.content_copy),
                    ),
                  ),
          ),
        ],
      );

  Widget switcher(bool big) => big
      ? Container()
      : InkWell(
          onTap: switchMode,
          child: const Center(
            child: Icon(Icons.swap_horiz),
          ),
        );

  Widget _realCenter(bool darkBkg) {
    String errorString = checkForHexString(_controller!.text) == false ? "Error" : "";
    bool error = errorString != '';

    return _insertMode
        ? Center(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              autofocus: true,
              textAlign: TextAlign.start,
              maxLength: 6,
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: error ? null : FontWeight.w600,
              ),
              onChanged: (String ts) => setState(() {}),
              decoration: InputDecoration(
                prefixText: "#FF ",
                prefixStyle: TextStyle(
                  inherit: true,
                  color: darkBkg ? const Color(0x88FFFFFF) : const Color(0x88000000),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
                errorText: error ? errorString : null,
              ),
            ),
          ))
        : InkWell(
            onTap: () => setState(() {
              _insertMode = true;
            }),
            child: Center(
              child: Text(
                "#FF ${_color!.hexString}",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ThemeData.estimateBrightnessForColor(_color!) == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          );
  }

  void confirmInsert() => setState(() {
        _color = hexToColor(_controller!.text);
        _updateHsvFromColor();
        widget.onChanged(_color);
        _insertMode = false;
      });

  final double _hsvSliderHeight = 6;
  Widget _hueSlider(Color activeColor, SliderThemeData sliderThemeOfContext) => SliderTheme(
      data: sliderThemeOfContext.copyWith(
        thumbColor: HSVColor.fromAHSV(
          1.0,
          _hue,
          1.0,
          1.0,
        ).toColor(),
        thumbShape: BorderRoundSliderThumbShape(
          border: 2,
          enabledThumbRadius: 8.0,
          borderColor: activeColor,
        ),
        trackHeight: _hsvSliderHeight,
        trackShape: ShadeRectangularSliderTrackShape(
            gradient: LinearGradient(
                colors: _interpolate(360, 0.0, 360)
                    .map<Color>(
                      (double x) => HSVColor.fromAHSV(
                        1.0,
                        x,
                        1.0,
                        1.0,
                      ).toColor(),
                    )
                    .toList())),
      ),
      child: AdvancedSlider(
        height: CustomColorPicker.sliderHeight,
        name: 'Hue: ${_hue.toInt()}°',
        value: _hue,
        max: 360.0,
        min: 0.0,
        onChanged: (double newHue) {
          setState(() {
            _hue = newHue;
            _updateColorFromHsv();
            widget.onChanged(_color);
          });
        },
        buttonDivision: 1.0,
      ));

  Widget _saturationSlider(Color activeColor, SliderThemeData sliderThemeOfContext) => SliderTheme(
        data: sliderThemeOfContext.copyWith(
          thumbColor: _color,
          thumbShape: BorderRoundSliderThumbShape(
            border: 2,
            enabledThumbRadius: 8.0,
            borderColor: activeColor,
          ),
          trackHeight: _hsvSliderHeight,
          trackShape: ShadeRectangularSliderTrackShape(
              gradient: LinearGradient(
                  colors: _interpolate(100, 0.0, 1.0)
                      .map<Color>(
                        (double x) => HSVColor.fromAHSV(
                          1.0,
                          _hue,
                          x,
                          _value,
                        ).toColor(),
                      )
                      .toList())),
        ),
        child: AdvancedSlider(
          height: CustomColorPicker.sliderHeight,
          name: 'Saturation: ${(_sat * 100).toInt()} %',
          value: _sat,
          max: 1.0,
          min: 0.0,
          onChanged: (double newSat) {
            setState(() {
              _sat = newSat;
              _updateColorFromHsv();
              widget.onChanged(_color);
            });
          },
          buttonDivision: 0.01,
        ),
      );

  Widget _valueSlider(Color activeColor, SliderThemeData sliderThemeOfContext) => SliderTheme(
        data: sliderThemeOfContext.copyWith(
          thumbColor: _color,
          thumbShape: BorderRoundSliderThumbShape(
            border: 2,
            enabledThumbRadius: 8.0,
            borderColor: activeColor,
          ),
          trackHeight: _hsvSliderHeight,
          trackShape: ShadeRectangularSliderTrackShape(
              gradient: LinearGradient(
                  colors: _interpolate(100, 0.0, 1.0)
                      .map<Color>(
                        (double x) => HSVColor.fromAHSV(
                          1.0,
                          _hue,
                          _sat,
                          x,
                        ).toColor(),
                      )
                      .toList())),
        ),
        child: AdvancedSlider(
          height: CustomColorPicker.sliderHeight,
          name: 'Value: ${(_value * 100).toInt()} %',
          value: _value,
          max: 1.0,
          min: 0.0,
          onChanged: (double newValue) {
            setState(() {
              _value = newValue;
              _updateColorFromHsv();
              widget.onChanged(_color);
            });
          },
          buttonDivision: 0.01,
        ),
      );

  List<double> _interpolate(int n, double min, double max) {
    List<double> result = <double>[];
    double i = min;
    double step = (max - min) / (n - 1);
    while (i <= max) {
      result.add(i);
      i += step;
    }
    return result;
  }
}

bool checkForHexString(String input) {
  RegExp hexcolor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  bool errorFound = false;
  try {
    hexToColor(input);
  } catch (e) {
    errorFound = true;
  }
  if (errorFound == true) return false;

  return hexcolor.hasMatch(input);
}

/// Construct a color from a hex code string, of the format RRGGBB.
Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode.substring(0, 6), radix: 16) + 0xFF000000);
}
