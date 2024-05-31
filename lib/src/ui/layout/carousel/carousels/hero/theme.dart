part of "../../m3_carousel.dart";

class HeroCarouselTheme extends M3CarouselTheme<HeroItemState> {
  const HeroCarouselTheme({super.direction = Axis.horizontal});

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
  double get widthSmallMin => 56;

  @override
  double get widthSmallMax => 56;

  @override
  double get widthLarge => 40;

  @override
  double get widthMedium => (widthLarge + widthSmallMax) / 2;

  @override
  M3CarouselItemDecorator<HeroItemState> getDecorator() =>
      HeroDecorator(axis: direction, targetBorderRadius: borderRadius);

  @override
  M3CarouselLayouter<HeroItemState> getLayouter(double displaySize) => HeroLayouter(
        D: displaySize,
        A: firstPadding,
        Z: lastPadding,
        t: widthLowerLimit,
        b: inBetweenPadding,
        axis: direction,
        s: widthSmallMin,
      );
}
