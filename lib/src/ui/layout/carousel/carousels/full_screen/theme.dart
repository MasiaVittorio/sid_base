part of "../../m3_carousel.dart";

class FullScreenCarouselTheme extends M3CarouselTheme<FullScreenItemState> {
  const FullScreenCarouselTheme({
    this.direction = Axis.vertical,
  });

  @override
  TextStyle titleStyle(BuildContext context) => context.theme.textTheme.titleMedium!;

  @override
  TextStyle subtitleStyle(BuildContext context) => context.theme.textTheme.bodySmall!;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(12);

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
      FullScreenDecorator(axis: direction, targetBorderRadius: borderRadius);

  @override
  final Axis direction;

  @override
  M3CarouselLayouter<FullScreenItemState> getLayouter(double displaySize) => FullScreenLayouter(
        D: displaySize,
        b: inBetweenPadding,
        axis: direction,
      );
}
