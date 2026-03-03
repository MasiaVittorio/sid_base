import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedListed extends ImplicitlyAnimatedWidget {
  const AnimatedListed({
    super.key,
    required this.listed,
    this.axis = Axis.vertical,
    this.axisAlignment = -1,
    this.child,
    Curve? curve,
    super.duration = const Duration(milliseconds: 250),
    this.overlapSizeAndOpacity = 0.0,
  }) : super(curve: curve ?? Curves.ease);

  final double axisAlignment;
  final Axis axis;
  final bool listed;
  final Widget? child;
  final double overlapSizeAndOpacity;
  @override
  AnimatedWidgetBaseState<AnimatedListed> createState() =>
      _DivisionAnimateState();
}

class _DivisionAnimateState extends AnimatedWidgetBaseState<AnimatedListed> {
  Tween<double>? _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween =
        visitor(
              _tween,
              widget.listed ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final double val = _tween!.evaluate(animation);

    return FractionallyListed(
      value: val,
      axis: widget.axis,
      axisAlignment: widget.axisAlignment,
      overlapSizeAndOpacity: widget.overlapSizeAndOpacity,
      child: widget.child,
    );
  }
}

class FractionallyListed extends StatelessWidget {
  const FractionallyListed({
    super.key,
    required this.value,
    required this.child,
    this.axis = Axis.vertical,
    this.axisAlignment = -1,
    this.overlapSizeAndOpacity = 0.0,
  });

  final double axisAlignment;
  final Axis axis;
  final Widget? child;
  final double overlapSizeAndOpacity;
  final double value;

  @override
  Widget build(BuildContext context) {
    final value = this.value.clamp(0, 1);
    final double overlap = overlapSizeAndOpacity.clamp(0.0, 1.0);

    final double maxSizeVal = 1 / 2 + overlap / 2;

    final double sizeFactor = value.rangeMap(from: (0, maxSizeVal));

    final double minOpacityVal = 1 / 2 - overlap / 2;

    final double opacity = value.rangeMap(from: (minOpacityVal, 1));

    return ClipRect(
      child: Align(
        alignment: Alignment(
          axis == Axis.horizontal ? axisAlignment : 0.0,
          axis == Axis.vertical ? axisAlignment : 0.0,
        ),
        widthFactor: axis == Axis.horizontal ? sizeFactor : 1.0,
        heightFactor: axis == Axis.vertical ? sizeFactor : 1.0,
        child: Opacity(opacity: opacity, child: child),
      ),
    );
  }
}
