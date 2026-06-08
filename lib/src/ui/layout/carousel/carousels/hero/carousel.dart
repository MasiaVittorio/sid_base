part of '../../m3_carousel.dart';

class HeroCarousel extends M3Carousel<HeroItemState> {
  HeroCarousel({
    super.key,
    super.initialIndex = 0,
    super.theme,
    required super.itemBuilder,
    super.itemCount,
    super.loop = false,
    super.autoFocusOnTap = true,
    super.openBuilder,
    super.defaultTheme = const HeroCarouselTheme(),
  });
}
