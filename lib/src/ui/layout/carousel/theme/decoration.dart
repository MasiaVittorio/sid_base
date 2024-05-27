part of "../m3_carousel.dart";

abstract class M3CarouselItemDecorator {
  const M3CarouselItemDecorator();
  Widget build(
    BuildContext context,
    double future,
    Widget content,
    ImageProvider image,
  );
}
