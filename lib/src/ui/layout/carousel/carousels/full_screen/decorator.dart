part of "../../m3_carousel.dart";

class FullScreenDecorator extends M3CarouselItemDecorator<FullScreenItemState> {
  const FullScreenDecorator({required super.axis, required super.borderRadius});

  @override
  double mainAxisAlignment(double future) {
    return -1 * ((future).clamp(-1, 1));
  }
}
