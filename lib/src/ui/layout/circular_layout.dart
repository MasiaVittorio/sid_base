import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

extension AngleExtensions on num {
  // ignore: unused_element
  double get normalizeRadians => this % (2 * math.pi);

  double get normalizeDegrees => this % (360);

  double get radToDeg => this * 180 / math.pi;
  // ignore: unused_element
  double get degToRad => this * math.pi / 180;

  // ignore: unused_element
  double get quarterTurnsToDegrees => this * 90;
  // ignore: unused_element
  double get quarterTurnsToRadians => this * math.pi / 2;

  double clockwiseTo(num other) => (this - other).normalizeDegrees;
  // ignore: unused_element
  bool closerClockwise(num other) => clockwiseTo(other) < 360 / 2;

  double closerAngleDistanceTo(num other) {
    final n = clockwiseTo(other);
    if (n > 180) return 360 - n;
    return n;
  }
}

class CircularLayout extends StatelessWidget {
  final List<Widget> children;
  final List<Widget>? labels;
  final double labelPadding;
  final List<double> angles;
  final List<double>? maxDistanceFractions;

  static List<double> anglesFromCenterAndSpan(
    double center, // clockwise from x axis
    double span, // positive value in ]0, 360]
    int children, {
    bool clockwise = true,
  }) {
    if (children == 0) return [];
    assert(children > 0);
    assert(span > 0);
    assert(span <= 360);
    final int inv = clockwise ? -1 : 1;
    final double amp = span.abs();
    final double step = amp / children;
    final double start = (center - inv * (amp / 2)).normalizeDegrees;
    return <double>[
      for (int i = 0; i < children; i++) (start + step * inv * (0.5 + i)).normalizeDegrees,
    ];
  }

  static List<double> anglesFromStartAngleAndFullTurn(
    double start, // still intended counterclockwise
    int children, {
    bool clockwise = true,
  }) {
    final int inv = clockwise ? -1 : 1;
    final double step = 360 / children;
    return <double>[
      for (int i = 0; i < children; i++) (start + step * inv * i).normalizeDegrees,
    ];
  }

  CircularLayout({
    required this.children,
    required this.angles,
    this.labels,
    this.labelPadding = 8.0,
    this.maxDistanceFractions,
    super.key,
  })  : assert(children.isNotEmpty),
        assert((labels == null) || (labels.length == children.length));

  @override
  Widget build(BuildContext context) {
    final bool alsoLabels = labels != null && labels!.isNotEmpty;
    return CustomMultiChildLayout(
      delegate: _CircularLayoutDelegate(
        itemCount: children.length,
        alsoLabels: alsoLabels,
        labelPadding: labelPadding,
        angles: angles,
        maxDistanceFractions: maxDistanceFractions,
      ),
      children: [
        for (int i = 0; i < children.length; ++i)
          LayoutId(
            id: _getChildId(i),
            child: children[i],
          ),
        if (alsoLabels)
          for (int i = 0; i < labels!.length; ++i)
            LayoutId(
              id: _getLabelId(i),
              child: labels![i],
            ),
      ],
    );
  }
}

const String _kLayoutId = 'ÇircularLayoutId';
const String _kLayoutIdLabel = 'ÇircularLayoutIdLabel';
String _getChildId(int i) => '$_kLayoutId$i';
String _getLabelId(int i) => '$_kLayoutIdLabel$i';

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  final bool alsoLabels;
  final double labelPadding;
  final List<double> angles;
  final List<double>? maxDistanceFractions;

  _CircularLayoutDelegate({
    required this.itemCount,
    required this.angles,
    required this.alsoLabels,
    required this.labelPadding,
    required this.maxDistanceFractions,
  });

  static double offsetX(Offset center, Size childSize, double radius, double itemAngle) =>
      (center.dx - childSize.width / 2) + (radius - childSize.width / 2) * math.cos(itemAngle);
  static double offsetY(Offset center, Size childSize, double radius, double itemAngle) =>
      (center.dy - childSize.height / 2) + (radius - childSize.height / 2) * math.sin(itemAngle);

  Offset offsetChild(Offset center, Size childSize, double radius, double itemAngle) => Offset(
        offsetX(center, childSize, radius, itemAngle),
        offsetY(center, childSize, radius, itemAngle),
      );
  Offset offsetChildNew(Offset center, Size childSize, double externalDistance, double itemAngle) {
    final double w = childSize.width;
    final double h = childSize.height;
    final double d = math.sqrt(w*w + h*h);
    final double childRadius = d / 2;
    final Offset childCenter = center + Offset.fromDirection(itemAngle, externalDistance - childRadius);
    return childCenter - Offset(w / 2, h / 2);
  }

  @override
  void performLayout(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    for (int i = 0; i < itemCount; i++) {
      final String childId = _getChildId(i);

      if (hasChild(childId)) {
        final Size childSize = layoutChild(childId, BoxConstraints.loose(size));
        final double itemAngle = angles[i].degToRad;
        final childOffset = offsetChildNew(
          center, 
          childSize, 
          radius * (maxDistanceFractions?.elementAt(i) ?? 1), 
          itemAngle,
        );

        positionChild(
          childId,
          childOffset,
        );

        if (alsoLabels) {
          final String labelId = _getLabelId(i);
          if (hasChild(labelId)) {
            final Size labelSize = layoutChild(labelId, BoxConstraints.loose(size));
            final bool right = itemAngle < math.pi / 2 || itemAngle >= math.pi * 3 / 2;
            positionChild(
              labelId,
              childOffset +
                  Offset(
                      right ? (childSize.width + labelPadding) : (-labelSize.width - labelPadding),
                      (childSize.height - labelSize.height) / 2),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
      !listEquals(oldDelegate.angles, angles) ||
      !listEquals(oldDelegate.maxDistanceFractions, maxDistanceFractions) ||
      alsoLabels != oldDelegate.alsoLabels ||
      labelPadding != oldDelegate.labelPadding;
}
