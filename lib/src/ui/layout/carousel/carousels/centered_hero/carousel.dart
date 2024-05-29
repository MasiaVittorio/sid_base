part of '../../m3_carousel.dart';

class CenteredHeroCarousel extends M3Carousel<CenteredHeroItemState> {
  const CenteredHeroCarousel({
    super.key,
    super.initialIndex = 0,
    super.theme,
    required super.itemBuilder,
    super.itemCount,
    super.loop = false,
    super.autoFocusOnTap = true,
    super.openBuilder,
    super.defaultTheme = const CenteredHeroCarouselTheme(),
  });
}
