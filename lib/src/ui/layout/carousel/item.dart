part of 'm3_carousel.dart';

class CarouselItem<T extends CarouselItemState> {
  final ImageProvider? background;

  // page index can be different from item index if there's loop activated
  final Widget? Function(BuildContext context, T state, int pageIndex)? contentBuilder;

  final VoidCallback? overrideOnTap;

  final Gradient? gradient;

  CarouselItem({
    required this.background,
    required this.contentBuilder,
    this.overrideOnTap,
    this.gradient = const LinearGradient(
      colors: [
        Color(0x66000000),
        Color(0x1a000000),
        Color(0x00000000),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  });
}
