part of '../radio_slider.dart';

class _VisualSlider extends StatelessWidget {
  const _VisualSlider({
    required this.height,
    required this.width,
    required this.elevate,
    required this.color,
  });

  final double height;
  final double width;
  final bool elevate;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (elevate) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: BorderRadius.circular(_RadioSliderState._radius),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 3,
              color: Color(0x59000000),
              offset: Offset(0, 0.5),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(_RadioSliderState._radius),
        ),
      );
    }
  }
}
