part of '../../m3_carousel.dart';

class MultiBrowseCarousel extends M3Carousel<MultiBrowseItemState> {
  const MultiBrowseCarousel({
    super.key,
    super.initialIndex = 0,
    super.theme,
    required super.itemBuilder,
    super.itemCount,
    super.loop = false,
    super.autoFocusOnTap = true,
    super.openBuilder,
    super.defaultTheme = const MultiBrowseCarouselTheme(),
  });
}
