part of "../../m3_carousel.dart";

class MultiBrowseDecorator
    extends M3CarouselItemDecorator<MultiBrowseItemState> {
  const MultiBrowseDecorator({
    required super.axis,
    required super.targetBorderRadius,
    required super.defaultBackgroundColor,
    required this.maxFuture,
  });

  final int maxFuture;

  @override
  double mainAxisBackgroundAlignment(double future) =>
      -1 *
      ((switch (future) {
        >= 0 => future / maxFuture,
        _ => future,
      }).clamp(-1, 1));
}
