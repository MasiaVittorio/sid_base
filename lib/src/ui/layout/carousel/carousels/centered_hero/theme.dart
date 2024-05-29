part of "../../m3_carousel.dart";

class CenteredHeroCarouselTheme extends M3CarouselTheme<CenteredHeroItemState> {
  const CenteredHeroCarouselTheme();

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
  double get widthLarge => 40;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator<CenteredHeroItemState> getDecorator() =>
      CenteredHeroDecorator(axis: direction, borderRadius: borderRadius);

  @override
  Axis get direction => Axis.horizontal;

  @override
  M3CarouselLayouter<CenteredHeroItemState> getLayouter(double displaySize) => CenteredHeroLayouter(
        D: displaySize,
        A: firstPadding,
        Z: lastPadding,
        t: widthLowerLimit,
        b: inBetweenPadding,
        axis: direction,
        s: widthSmallMin,
      );
}
