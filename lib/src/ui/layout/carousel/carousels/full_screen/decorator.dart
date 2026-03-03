part of "../../m3_carousel.dart";

class FullScreenDecorator extends M3CarouselItemDecorator<FullScreenItemState> {
  const FullScreenDecorator({
    required super.axis,
    required super.targetBorderRadius,
    required super.defaultBackgroundColor,
  });

  @override
  BorderRadius effectiveBorderRadius(double future) {
    return BorderRadius.lerp(
      BorderRadius.zero,
      targetBorderRadius,
      future.abs().clamp(0, 1).rangeMap(from: (0, 0.05)),
    )!;
  }
}
