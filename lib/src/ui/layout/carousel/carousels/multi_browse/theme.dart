part of "../../m3_carousel.dart";

class MultiBrowseCarouselTheme extends M3CarouselTheme<MultiBrowseItemState> {
  const MultiBrowseCarouselTheme({super.direction = Axis.horizontal});

  @override
  TextStyle titleStyle(BuildContext context) => context.theme.textTheme.titleMedium!;

  @override
  TextStyle subtitleStyle(BuildContext context) => context.theme.textTheme.bodySmall!;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(28);

  @override
  double get firstPadding => 16;

  @override
  double get lastPadding => 16;

  @override
  double get inBetweenPadding => 8;

  @override
  double get widthLowerLimit => 12;

  @override
  double get widthSmallMin => 40;

  @override
  double get widthSmallMax => 40;

  @override
  double get widthLarge => 180;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator<MultiBrowseItemState> getDecorator() => MultiBrowseDecorator(
        axis: direction,
        targetBorderRadius: borderRadius,
        maxFuture: 3,
      );

  @override
  M3CarouselLayouter<MultiBrowseItemState> getLayouter(double displaySize) => MultiBrowseLayouter(
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
