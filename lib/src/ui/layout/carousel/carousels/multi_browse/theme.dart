part of "../../m3_carousel.dart";

class MultiBrowseCarouselTheme extends M3CarouselTheme {
  const MultiBrowseCarouselTheme();

  @override
  TextStyle titleStyle(BuildContext context) => context.theme.textTheme.titleMedium!;

  @override
  TextStyle subtitleStyle(BuildContext context) => context.theme.textTheme.bodySmall!;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(28);

  @override
  double get firstPadding => 24;

  @override
  double get lastPadding => 24;

  @override
  double get inBetweenPadding => 12;

  @override
  double get widthLowerLimit => 16;

  @override
  double get widthSmallMin => 40;

  @override
  double get widthSmallMax => 48;

  @override
  double get widthLarge => 180;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator getDecorator() => MultiBrowseDecorator(
        axis: direction,
        maxFuture: 3,
      );

  @override
  Axis get direction => Axis.horizontal;

  @override
  M3CarouselLayouter getLayouter(double displaySize) => MultiBrowseLayouter(
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
