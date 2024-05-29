part of 'm3_carousel.dart';

sealed class CarouselItemState {
  const CarouselItemState();

  double get contentOpacity;
  bool get canBeOpened;

  // void onTap(PageController controller);
}
