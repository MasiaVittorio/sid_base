part of "../../m3_carousel.dart";

class FullScreenCarouselTheme extends M3CarouselTheme<FullScreenItemState> {
  const FullScreenCarouselTheme({
    super.direction = Axis.vertical,
    this.defaultBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });
  final Color? defaultBackgroundColor;

  @override
  TextStyle titleStyle(BuildContext context) =>
      context.theme.textTheme.titleMedium!;

  @override
  TextStyle subtitleStyle(BuildContext context) =>
      context.theme.textTheme.bodySmall!;

  @override
  final BorderRadius borderRadius;

  @override
  double get firstPadding => 0;

  @override
  double get lastPadding => 0;

  @override
  double get inBetweenPadding => 16;

  @override
  double get widthLowerLimit => 16;

  @override
  double get widthSmallMin => 0;

  @override
  double get widthSmallMax => 0;

  @override
  double get widthLarge => 0;

  @override
  double get widthMedium => 0;

  @override
  M3CarouselItemDecorator<FullScreenItemState> getDecorator() =>
      FullScreenDecorator(
        axis: direction,
        targetBorderRadius: borderRadius,
        defaultBackgroundColor: defaultBackgroundColor,
      );

  @override
  M3CarouselLayouter<FullScreenItemState> getLayouter(double displaySize) =>
      FullScreenLayouter(D: displaySize, b: inBetweenPadding, axis: direction);
}
