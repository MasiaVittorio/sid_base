// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

abstract class CarouselItemDecorator {
  const CarouselItemDecorator();
  Widget build(
    BuildContext context,
    double future,
    Widget content,
    ImageProvider image,
  );
}

class M3CarouselItemDecorator extends CarouselItemDecorator {
  const M3CarouselItemDecorator({
    required this.axis,
    required this.maxFuture,
  });

  final Axis axis;
  final int maxFuture;

  @override
  Widget build(
    BuildContext context,
    double future,
    Widget content,
    ImageProvider image,
  ) {
    final double mainAxisAlignment = -1 * ((future / maxFuture).clamp(-1, 1));
    final theme = context.provide<M3CarouselTheme>();
    final mTheme = context.theme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: theme.borderRadius,
        color: mTheme.colorScheme.secondaryContainer,
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          alignment: switch (axis) {
            Axis.horizontal => Alignment(mainAxisAlignment, 0),
            Axis.vertical => Alignment(0, mainAxisAlignment),
          },
        ),
      ),
      child: content,
    );
  }
}
