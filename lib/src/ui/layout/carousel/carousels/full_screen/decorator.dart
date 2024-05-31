part of "../../m3_carousel.dart";

class FullScreenDecorator extends M3CarouselItemDecorator<FullScreenItemState> {
  const FullScreenDecorator({required super.axis, required super.targetBorderRadius});

  @override
  BorderRadius effectiveBorderRadius(double future) {
    return BorderRadius.lerp(
      BorderRadius.zero,
      targetBorderRadius,
      future.abs().clamp(0, 1).mapFromRange(0, 0.05),
    )!;
  }
}
