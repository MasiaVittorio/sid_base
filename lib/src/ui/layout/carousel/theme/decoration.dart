// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "../m3_carousel.dart";

abstract class M3CarouselItemDecorator<T extends CarouselItemState> {
  const M3CarouselItemDecorator({
    required this.axis,
    required this.targetBorderRadius,
    required this.defaultBackgroundColor,
  });
  final Axis axis;
  final BorderRadius targetBorderRadius;
  final Color? defaultBackgroundColor;

  BorderRadius effectiveBorderRadius(double future) => targetBorderRadius;

  Widget build(
    BuildContext context,
    double future,
    Widget content,
    ImageProvider? image,
    bool round,
  ) {
    final al = mainAxisBackgroundAlignment(future);
    return Container(
      clipBehavior: round ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        borderRadius: round ? effectiveBorderRadius(future) : null,
        color:
            defaultBackgroundColor ??
            context.theme.colorScheme.secondaryContainer,
        image: switch (image) {
          null => null,
          ImageProvider image => DecorationImage(
            image: image,
            fit: BoxFit.cover,
            alignment: switch (axis) {
              Axis.horizontal => Alignment(al, 0),
              Axis.vertical => Alignment(0, al),
            },
          ),
        },
      ),
      child: content,
    );
  }

  double mainAxisBackgroundAlignment(double future) {
    return -1 * ((future).clamp(-1, 1));
  }

  AlignmentGeometry contentAlignment(double future) {
    return axis.fold(
      ifVertifcal: () => Alignment(0, (-future).clamp(-1, 1)),
      ifHorizontal: () => Alignment((-future).clamp(-1, 1), 0),
    );
  }
}
