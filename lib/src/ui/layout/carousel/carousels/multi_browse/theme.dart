part of "../../m3_carousel.dart";

class MultiBrowseCarouselTheme extends M3CarouselTheme<MultiBrowseItemState> {
  const MultiBrowseCarouselTheme({
    super.direction = Axis.horizontal,
    this.defaultBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.inBetweenPadding = 8,
    this.firstPadding = 16,
    this.lastPadding = 16,
    this.widthLowerLimit = 12,
    this.widthLarge = 180,
    this.widthSmallMin = 40,
    this.widthSmallMax = 40,
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
  final double firstPadding;

  @override
  final double lastPadding;

  @override
  final double inBetweenPadding;

  @override
  final double widthLowerLimit;

  @override
  final double widthSmallMin;

  @override
  final double widthSmallMax;

  @override
  final double widthLarge;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator<MultiBrowseItemState> getDecorator() =>
      MultiBrowseDecorator(
        axis: direction,
        targetBorderRadius: borderRadius,
        maxFuture: 3,
        defaultBackgroundColor: defaultBackgroundColor,
      );

  @override
  M3CarouselLayouter<MultiBrowseItemState> getLayouter(double displaySize) =>
      MultiBrowseLayouter(
        D: displaySize,
        targetLarge: widthLarge,
        A: firstPadding,
        Z: lastPadding,
        t: widthLowerLimit,
        b: inBetweenPadding,
        axis: direction,
        sMin: widthSmallMin,
        sMax: widthSmallMax,
      );
}
