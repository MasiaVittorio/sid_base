import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BiggestSquare extends StatelessWidget {
  const BiggestSquare({
    super.key,
    required this.child,
    this.shrink = false,
    this.fallback = 56,
  });
  final Widget child;
  final bool shrink;
  final double fallback;

  @override
  Widget build(BuildContext context) {
    return BiggestAspectRatio(
      aspectRatio: 1,
      fallbackWidth: fallback,
      shrink: shrink,
      child: child,
    );
  }
}

class BiggestAspectRatio extends SingleChildRenderObjectWidget {
  const BiggestAspectRatio({
    super.key,
    super.child,
    this.fallbackWidth = 56,
    this.shrink = false,
    required this.aspectRatio,
  }) : assert(aspectRatio > 0);

  final double fallbackWidth;
  // width to height
  final double aspectRatio;
  final bool shrink;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RatioRenderObject(
      fallbackWidth: fallbackWidth,
      shrink: shrink,
      aspectRatio: aspectRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    // ignore: library_private_types_in_public_api
    _RatioRenderObject renderObject,
  ) {
    renderObject.fallbackWidth = fallbackWidth;
    renderObject.shrink = shrink;
    renderObject.aspectRatio = aspectRatio;
    renderObject.markNeedsLayout();
  }
}

class _RatioRenderObject extends RenderProxyBox {
  double fallbackWidth;
  bool shrink;
  double aspectRatio;

  _RatioRenderObject({
    required this.fallbackWidth,
    required this.shrink,
    required this.aspectRatio,
  });

  @override
  void performLayout() {
    final cw = constraints.maxWidth;
    final ch = constraints.maxHeight;

    Size ss = switch (cw / ch > aspectRatio) {
      // too wide constraints
      true => Size(ch * aspectRatio, ch),
      // too tall
      false => Size(cw, cw / aspectRatio),
    };
    if (!ss.isFinite) {
      ss = Size(fallbackWidth, fallbackWidth / aspectRatio);
    }

    child?.layout(
      BoxConstraints(maxWidth: ss.width, maxHeight: ss.height),
      parentUsesSize: true,
    );
    final Size desired = shrink ? (child?.size ?? ss) : ss;

    size = constraints.constrain(desired);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (width.isFinite) {
      if (shrink) {
        return child?.getMinIntrinsicHeight(width) ?? width / aspectRatio;
      } else {
        return width / aspectRatio;
      }
    } else {
      return child?.getMinIntrinsicHeight(width) ??
          (fallbackWidth / aspectRatio);
    }
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (height.isFinite) {
      if (shrink) {
        return child?.getMinIntrinsicWidth(height) ?? height * aspectRatio;
      } else {
        return height * aspectRatio;
      }
    } else {
      return child?.getMinIntrinsicWidth(height) ??
          (fallbackWidth * aspectRatio);
    }
  }
}
