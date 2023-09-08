import 'package:flutter/material.dart';

class ExternalCircleClipper extends StatelessWidget {
  const ExternalCircleClipper({
    super.key,
    required this.child,
    required this.fraction,
    required this.mode,
  });
  final Widget child;
  final ExternalCircleClipperMode mode;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipBehavior: Clip.antiAlias,
      clipper: _Clipper(mode, fraction),
      child: child,
    );
  }
}

enum ExternalCircleClipperMode {
  fromCorners,
  fromSides,
}

class _Clipper extends CustomClipper<Path> {
  final ExternalCircleClipperMode mode;
  final double fraction;

  _Clipper(this.mode, this.fraction);

  @override
  Path getClip(Size size) {
    final double baseR = switch (mode) {
      ExternalCircleClipperMode.fromCorners => size.bottomRight(Offset.zero).distance / 2,
      ExternalCircleClipperMode.fromSides => size.longestSide / 2,
    };
    final double radius = baseR * fraction;

    final Path circle = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        Radius.circular(radius),
      ));

    final Path frame = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (fraction == 0) return frame;
    return Path.combine(PathOperation.difference, frame, circle);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    if (oldClipper is _Clipper) {
      return oldClipper.fraction != fraction || oldClipper.mode != mode;
    }
    return true;
  }
}
