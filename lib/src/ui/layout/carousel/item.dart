part of 'm3_carousel.dart';

class CarouselItem<T extends CarouselItemState> {
  final ImageProvider background;
  final Widget Function(BuildContext context, T state, double largeWidth) contentBuilder;
  CarouselItem({
    required this.background,
    required this.contentBuilder,
  });
}
