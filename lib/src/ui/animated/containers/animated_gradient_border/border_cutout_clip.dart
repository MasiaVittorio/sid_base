import 'package:flutter/material.dart';

class BorderCutoutClip extends StatelessWidget {
  const BorderCutoutClip({
    super.key,
    required this.child,
    required this.thickness,
    required this.radius,
  });

  final Widget child;
  final double thickness;
  final Radius radius;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CenterCutPath(
        thickness: thickness,
        radius: radius,
      ),
      child: child,
    );
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double thickness;
  final Radius radius;

  _CenterCutPath({
    required this.thickness,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final t = thickness;
    final w = size.width;
    final h = size.height;

    // big enough for the shadows also
    final Rect external = Rect.fromLTRB(-w, -h, 2 * w, 2 * h);

    final Rect internal = Rect.fromLTRB(t, t, w - t, h - t);

    final Radius internalRadius = Radius.elliptical(
      (radius.x - t).clamp(0, radius.x),
      (radius.y - t).clamp(0, radius.y),
    );

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
          internal,
          internalRadius,
        ),
      )
      ..addRect(external);
  }

  @override
  bool shouldReclip(_CenterCutPath oldClipper) {
    return oldClipper.thickness != thickness || oldClipper.radius != radius;
  }
}
