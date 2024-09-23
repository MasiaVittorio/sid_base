import 'dart:math';

import 'package:flutter/material.dart';

class BiggestSquare extends StatelessWidget {
  const BiggestSquare({
    super.key,
    required this.builder,
    this.fallbackSize = 50,
    this.shrink = false,
  });

  final Widget Function(BuildContext context, double size) builder;
  final double fallbackSize;
  final bool shrink;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        double s = min(c.maxHeight, c.maxWidth);
        if (s.isNaN || s.isInfinite) s = fallbackSize;
        if (shrink) return builder(context, s);
        return SizedBox.square(
          dimension: s,
          child: builder(context, s),
        );
      },
    );
  }
}
