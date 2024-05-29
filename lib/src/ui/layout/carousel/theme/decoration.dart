// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "../m3_carousel.dart";

abstract class M3CarouselItemDecorator<T extends CarouselItemState> {
  const M3CarouselItemDecorator({
    required this.axis,
    required this.borderRadius,
  });
  final Axis axis;
  final BorderRadius borderRadius;

  Widget build(
    BuildContext context,
    double future,
    Widget content,
    ImageProvider image,
    bool round,
  ) {
    final al = mainAxisAlignment(future);
    final mTheme = context.theme;
    return Container(
      clipBehavior: round ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        borderRadius: round ? borderRadius : null,
        color: mTheme.colorScheme.secondaryContainer,
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          alignment: switch (axis) {
            Axis.horizontal => Alignment(al, 0),
            Axis.vertical => Alignment(0, al),
          },
        ),
      ),
      child: content,
    );
  }

  double mainAxisAlignment(double future);
}
