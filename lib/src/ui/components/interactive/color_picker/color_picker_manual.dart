import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/ui/components/interactive/color_picker/components/advanced_slider/advanced_slider.dart';
import 'package:sid_base/src/ui/components/interactive/color_picker/components/advanced_slider/vertical_slider.dart';

///this takes a bit of code from another package to build
///the saturation / value rectangle: flutter_hsvcolor_picker

class ManualColorPicker extends StatefulWidget {
  final Color color;
  final Function(Color) onChanged;

  const ManualColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
  });

  @override
  State<ManualColorPicker> createState() => _ManualColorPickerState();
}

class _ManualColorPickerState extends State<ManualColorPicker> {
  late double _hue;
  late double _sat;
  late double _val;

  HSVColor get color => HSVColor.fromColor(widget.color);

  void _reset() {
    _hue = color.hue;
    _sat = color.saturation;
    _val = color.value;
  }

  Color get currentColor => HSVColor.fromAHSV(
        widget.color.alpha / 255.toDouble(),
        _hue,
        _sat,
        _val,
      ).toColor();

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (currentColor != widget.color) {
      _reset();
    }
  }

  Color get themeContrast => Theme.of(context).canvasColor.contrast;

  void colorFromHsv() => super.widget.onChanged(HSVColor.fromAHSV(
        color.alpha,
        _hue,
        _sat,
        _val,
      ).toColor());

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

  //Hue
  void hueOnChange(double value) => setState(() {
        _hue = value;
        colorFromHsv();
      });

  List<Color> get hueColors => _interpolate(360, 0.0, 360)
      .map<Color>((double x) => HSVColor.fromAHSV(
            1.0,
            x,
            1.0,
            1.0,
          ).toColor())
      .toList();

  //Saturation / Value
  void saturationValueOnChange(Offset value) => setState(() {
        _sat = value.dx;
        _val = value.dy;
        colorFromHsv();
      });

  //Saturation
  List<Color> get saturationColors =>
      [Colors.white, HSVColor.fromAHSV(1.0, _hue, 1.0, 1.0).toColor()];

  //Value
  final List<Color> valueColors = [Colors.transparent, Colors.black];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double padding = 8.0;
      return Material(
        child: Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding * 2),
              child: PalettePicker(
                  circleColor:
                      ThemeData.estimateBrightnessForColor(color.toColor()) == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                  width: constraints.maxWidth - padding * 2,
                  height: constraints.maxHeight - padding * 2,
                  position: Offset(_sat, _val),
                  onChanged: saturationValueOnChange,
                  leftRightColors: saturationColors,
                  topPosition: 1.0,
                  bottomPosition: 0.0,
                  topBottomColors: valueColors),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _hueSlider(themeContrast, constraints.maxHeight),
          ),
        ]),
      );
    });
  }

  Widget _hueSlider(Color activeColor, double height) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
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
        trackHeight: 8,
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
      child: VerticalSlider(
        height: height,
        width: 64,
        value: _hue,
        max: 360.0,
        min: 0.0,
        onChanged: (double newHue) {
          setState(() {
            hueOnChange(newHue);
          });
        },
      ));
}

class PalettePicker extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onChanged;

  final double leftPosition;
  final double rightPosition;
  final List<Color> leftRightColors;

  final double topPosition;
  final double bottomPosition;
  final List<Color> topBottomColors;

  final double width;
  final double height;

  final Color circleColor;

  const PalettePicker(
      {super.key,
      required this.width,
      required this.height,
      required this.position,
      required this.onChanged,
      this.circleColor = Colors.black,
      this.leftPosition = 0.0,
      this.rightPosition = 1.0,
      required this.leftRightColors,
      this.topPosition = 0.0,
      this.bottomPosition = 1.0,
      required this.topBottomColors});

  @override
  State<PalettePicker> createState() => _PalettePickerState();
}

class _PalettePickerState extends State<PalettePicker> {
  final GlobalKey paletteKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Offset get position => widget.position;
  double get leftPosition => widget.leftPosition;
  double get rightPosition => widget.rightPosition;
  double get topPosition => widget.topPosition;
  double get bottomPosition => widget.bottomPosition;

  /// Position(min, max) > Ratio(0, 1)
  Offset positionToRatio() {
    double ratioX = leftPosition < rightPosition
        ? positionToRatio2(position.dx, leftPosition, rightPosition)
        : 1.0 - positionToRatio2(position.dx, rightPosition, leftPosition);

    double ratioY = topPosition < bottomPosition
        ? positionToRatio2(position.dy, topPosition, bottomPosition)
        : 1.0 - positionToRatio2(position.dy, bottomPosition, topPosition);

    return Offset(ratioX, ratioY);
  }

  double positionToRatio2(double postiton, double minPostition, double maxPostition) {
    if (postiton < minPostition) return 0.0;
    if (postiton > maxPostition) return 1.0;
    return (postiton - minPostition) / (maxPostition - minPostition);
  }

  /// Ratio(0, 1) > Position(min, max)
  void ratioToPosition(Offset ratio) {
    RenderBox renderBox = paletteKey.currentContext!.findRenderObject() as RenderBox;
    Offset startposition = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    Offset updateOffset = ratio - startposition;

    double ratioX = updateOffset.dx / size.width;
    double ratioY = updateOffset.dy / size.height;

    double positionX = leftPosition < rightPosition
        ? ratioToPosition2(ratioX, leftPosition, rightPosition)
        : ratioToPosition2(1.0 - ratioX, rightPosition, leftPosition);

    double positionY = topPosition < bottomPosition
        ? ratioToPosition2(ratioY, topPosition, bottomPosition)
        : ratioToPosition2(1.0 - ratioY, bottomPosition, topPosition);

    Offset position = Offset(positionX, positionY);
    super.widget.onChanged(position);
  }

  double ratioToPosition2(double ratio, double minposition, double maxposition) {
    if (ratio < 0.0) return minposition;
    if (ratio > 1.0) return maxposition;
    return ratio * maxposition + (1.0 - ratio) * minposition;
  }

  Widget buildLeftRightColors() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: super.widget.leftRightColors)));
  }

  Widget buildTopBottomColors() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: super.widget.topBottomColors)));
  }

  Widget buildGestureDetector() {
    void update(details) => ratioToPosition(details.globalPosition);
    return GestureDetector(
        onPanStart: update,
        onPanDown: update,
        onPanUpdate: update,
        onTapDown: update,

        //To override eventual outer vertical lists' / sheets' gestures
        onVerticalDragDown: update,
        onVerticalDragUpdate: update,
        onVerticalDragStart: update,
        child: SizedBox(
            key: paletteKey,
            width: widget.width,
            height: widget.height,
            child: CustomPaint(
                painter:
                    _PalettePainter(ratio: positionToRatio(), circleColor: widget.circleColor))));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      buildLeftRightColors(),
      buildTopBottomColors(),
      buildGestureDetector(),
    ]);
  }
}

class _PalettePainter extends CustomPainter {
  final Offset? ratio;
  final Color? circleColor;
  _PalettePainter({this.ratio, this.circleColor}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBlack = Paint()
      ..color = circleColor ?? Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Offset offset = Offset(size.width * ratio!.dx, size.height * ratio!.dy);
    canvas.drawCircle(offset, 8, paintBlack);
  }

  @override
  bool shouldRepaint(_PalettePainter other) => true;
}
