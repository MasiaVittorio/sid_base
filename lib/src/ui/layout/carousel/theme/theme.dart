import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/ui/layout/carousel/theme/decoration.dart';
import 'package:sid_base/src/ui/layout/carousel/theme/layout.dart';

class M3CarouselTheme {
  const M3CarouselTheme();
  TextStyle titleStyle(BuildContext context) => context.theme.textTheme.titleMedium!;
  TextStyle subtitleStyle(BuildContext context) => context.theme.textTheme.bodySmall!;
  BorderRadius get borderRadius => BorderRadius.circular(28);
  double get firstPadding => 24;
  double get lastPadding => 24;
  double get inBetweenPadding => 12;
  double get widthLowerLimit => 16;
  double get widthSmallMin => 40;
  double get widthSmallMax => 48;
  double get widthLarge => 180;
  double get widthMedium => (widthLarge + widthSmallMax) / 2;
  CarouselItemDecorator getDecorator() => M3CarouselItemDecorator(
        axis: direction,
        maxFuture: 3,
      );
  Axis get direction => Axis.horizontal;

  CarouselLayouter getLayouter(double displaySize) => M3CarouselLayouter(
        D: displaySize,
        targetLarge: widthLarge,
        A: firstPadding,
        Z: lastPadding,
        t: widthLowerLimit,
        b: inBetweenPadding,
        axis: direction,
        sMin: widthSmallMin,
        sMax: widthSmallMax,
      );
}
