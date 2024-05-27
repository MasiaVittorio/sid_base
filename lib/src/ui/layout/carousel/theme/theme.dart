part of "../m3_carousel.dart";

abstract class M3CarouselTheme {
  const M3CarouselTheme();
  TextStyle titleStyle(BuildContext context);
  TextStyle subtitleStyle(BuildContext context);
  BorderRadius get borderRadius;
  double get firstPadding;
  double get lastPadding;
  double get inBetweenPadding;
  double get widthLowerLimit;
  double get widthSmallMin;
  double get widthSmallMax;
  double get widthLarge;
  double get widthMedium;
  M3CarouselItemDecorator getDecorator();
  Axis get direction;

  M3CarouselLayouter getLayouter(double displaySize);
}
