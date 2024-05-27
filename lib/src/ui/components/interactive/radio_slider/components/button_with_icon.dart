part of '../radio_slider.dart';

class _ButtonWithIcon extends StatelessWidget {
  const _ButtonWithIcon({
    required this.selectedColor,
    required this.item,
    required this.isShowing,
    required this.duration,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  final Duration duration;
  final Color? selectedColor;
  final bool isShowing;
  final RadioSliderItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RadioSliderThemeData? radioTheme = RadioSliderTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: AnimatedCrossFade(
            crossFadeState: isShowing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: IconTheme.merge(
              data: IconThemeData(
                  color: selectedColor ?? radioTheme?.selectedColor,
                  opacity: selectedColor?.opacity ?? radioTheme?.selectedColor?.opacity),
              child: item.selectedIcon ?? item.icon,
            ),
            secondChild: IconTheme.merge(
                data: IconThemeData(
                  color: theme.unselectedWidgetColor,
                ),
                child: item.icon),
            duration: duration,
          ),
        ),
        AnimatedListed(
          overlapSizeAndOpacity: 0.9,
          duration: duration,
          listed: isShowing,
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          curve: Curves.fastOutSlowIn,
          child: Container(
            height: height,
            width: width - height,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 4.0),
            child: DefaultTextStyle.merge(
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selectedColor ??
                      radioTheme?.selectedColor ??
                      theme.textTheme.bodyMedium?.color,
                ),
                child: item.title),
          ),
        ),
      ],
    );
  }
}
