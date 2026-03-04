import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sid_base/src/all.dart';

class CustomRowChild {
  final Widget child;
  final double expansion;

  CustomRowChild({required this.child, required this.expansion});
}

class AnimatedCustomRow extends ImplicitlyAnimatedWidget {
  const AnimatedCustomRow({
    super.key,
    required this.children,
    super.duration = Durations.medium2,
    super.curve = Easings.standard,
    this.minHorizontalMargin = 0,
  });

  final List<CustomRowChild> children;
  final double minHorizontalMargin;

  @override
  AnimatedWidgetBaseState<AnimatedCustomRow> createState() =>
      _DivisionAnimateState();
}

class _DivisionAnimateState extends AnimatedWidgetBaseState<AnimatedCustomRow> {
  List<Tween<double>> tweens = [];

  @override
  void didUpdateWidget(covariant AnimatedCustomRow oldWidget) {
    if (widget.children.length != oldWidget.children.length) {
      tweens.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    for (int i = 0; i < widget.children.length; i++) {
      if (tweens.length <= i) {
        tweens.add(
          visitor(
                null,
                widget.children[i].expansion,
                (value) => Tween<double>(begin: value),
              )
              as Tween<double>,
        );
      } else {
        tweens[i] =
            visitor(
                  tweens[i],
                  widget.children[i].expansion,
                  (value) => Tween<double>(begin: value),
                )
                as Tween<double>;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRow(
      minHorizontalMargin: widget.minHorizontalMargin,
      expansions: [
        for (int i = 0; i < widget.children.length; i++)
          if (tweens.length > i)
            tweens[i].evaluate(animation)
          else
            widget.children[i].expansion,
      ],
      children: [for (final c in widget.children) c.child],
    );
  }
}

/// A widget that takes a list of children and
class CustomRow extends MultiChildRenderObjectWidget {
  const CustomRow({
    super.key,
    required super.children,
    required this.expansions,
    this.minHorizontalMargin = 0,
  }) : assert(
         expansions.length == children.length,
         'The length of expansions must match the number of children.',
       );

  final double minHorizontalMargin;
  final List<double> expansions;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomRow(
      minHorizontalMargin: minHorizontalMargin,
      expansions: expansions,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderCustomRow renderObject,
  ) {
    renderObject.minHorizontalMargin = minHorizontalMargin;
    renderObject.expansions = expansions;
  }
}

class RenderCustomRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  double _minHorizontalMargin;
  double get minHorizontalMargin => _minHorizontalMargin;
  set minHorizontalMargin(double value) {
    if (_minHorizontalMargin == value) return;
    _minHorizontalMargin = value;
    markNeedsLayout();
  }

  List<double> _expansions;
  List<double> get expansions => _expansions;
  set expansions(List<double> value) {
    if (listEquals(value, _expansions)) return;
    _expansions = value;
    markNeedsLayout();
  }

  RenderCustomRow({
    required double minHorizontalMargin,
    required List<double> expansions,
  }) : _expansions = expansions,
       _minHorizontalMargin = minHorizontalMargin;

  // Sets up the data structure that holds the offset/position of each child
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    size = constraints.biggest;
    final maxHeight = size.height;

    RenderBox? child = firstChild;

    double eT = 0;
    for (final e in expansions) {
      eT += e;
    }

    double chW = 0; // total width of the children at their resting size
    List<double> widths = []; // resting widths of the children
    final measureConstraints = BoxConstraints(
      minWidth: 0,
      maxWidth: double.infinity,
      minHeight: 0,
      maxHeight: constraints.maxHeight,
    );
    while (child != null) {
      child.layout(measureConstraints, parentUsesSize: true);
      chW += child.size.width;
      widths.add(child.size.width);
      child = (child.parentData as MultiChildLayoutParentData).nextSibling;
    }

    double A = size.width - chW; // available space for expansion
    final List<double> fractions = [for (final e in expansions) e / eT];

    if (A <= 0) {
      // lay out each child next to the other
      layoutChildren(0, widths, fractions, 0, maxHeight);
      return;
    }
    final double p = minHorizontalMargin;

    if (A < 2 * p || p == 0) {
      layoutChildren(A, widths, fractions, 0, maxHeight);
      return;
    }

    final double alpha = fractions.first / 2;
    final double beta = fractions.last / 2;
    if (A * alpha < p && A * beta < p) {
      // let's make a smaller available space, leave some additional left and right margin
      // and the resulting space on the left and right will be fine
      // a = A - l - r;
      // l + a * alpha = p;   ->   l = p - a * alpha
      // r + a * beta = p;    ->   r = p - a * beta
      // a, l, r = ??? let's solve the system of equations
      // 1) a = A - (p - a * alpha) - (p - a * beta)
      //    a = A - 2 * p + a * (alpha + beta)
      //    a * (1 - alpha - beta) = A - 2 * p
      double a = (A - 2 * p) / (1 - alpha - beta);
      final double l = p - a * alpha;
      final double r = p - a * beta;
      a = A - l - r; // should definitely be already true, but let's make sure;
      layoutChildren(a, widths, fractions, l, maxHeight);
      return;
    } else if (A * alpha < p) {
      // same same, but the right side doesn't need to be reduced
      // a = A - l;
      // l + a * alpha = p;   ->   l = p - a * alpha
      // 1) a = A - (p - a * alpha)
      //    a = A - p + a * alpha
      //    a * (1 - alpha) = A - p
      double a = (A - p) / (1 - alpha);
      final double l = p - a * alpha;
      a = A - l; // should definitely be already true, but let's make sure;
      layoutChildren(a, widths, fractions, l, maxHeight);
      return;
    } else if (A * beta < p) {
      // same same, but the left side doesn't need to be reduced
      // a = A - r;
      // r + a * beta = p;    ->   r = p - a * beta
      // 1) a = A - (p - a * beta)
      //    a = A - p + a * beta
      //    a * (1 - beta) = A - p
      double a = (A - p) / (1 - beta);
      final double r = p - a * beta;
      a = A - r; // should definitely be already true, but let's make sure;
      layoutChildren(a, widths, fractions, 0, maxHeight);
      return;
    }

    layoutChildren(A, widths, fractions, 0, maxHeight);
    return;
  }

  void layoutChildren(
    double A, // available space for expansion
    List<double> widths, // resting widths of the children
    List<double> fractions, // fractions of the available space for each child
    double l, // left margin
    double maxHeight,
  ) {
    RenderBox? child = firstChild;
    double position = l;
    int i = 0;
    while (child != null) {
      final extra = A * fractions[i];
      final pd = child.parentData as MultiChildLayoutParentData;
      final width = widths[i] + extra;
      child.layout(
        BoxConstraints.tightFor(width: width, height: maxHeight),
        parentUsesSize: true,
      );
      pd.offset = Offset(position, 0);
      position += width;
      child = pd.nextSibling;
      i++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
