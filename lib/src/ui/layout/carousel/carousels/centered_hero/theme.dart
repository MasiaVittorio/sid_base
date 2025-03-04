part of "../../m3_carousel.dart";

class CenteredHeroCarouselTheme extends M3CarouselTheme<CenteredHeroItemState> {
  const CenteredHeroCarouselTheme({
    super.direction = Axis.horizontal,
    this.defaultBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
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
  double get widthLarge => 40;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator<CenteredHeroItemState> getDecorator() =>
      CenteredHeroDecorator(
        axis: direction,
        targetBorderRadius: borderRadius,
        defaultBackgroundColor: defaultBackgroundColor,
      );

  @override
  M3CarouselLayouter<CenteredHeroItemState> getLayouter(double displaySize) =>
      CenteredHeroLayouter(
        D: displaySize,
        A: firstPadding,
        Z: lastPadding,
        t: widthLowerLimit,
        b: inBetweenPadding,
        axis: direction,
        s: widthSmallMin,
      );
}
