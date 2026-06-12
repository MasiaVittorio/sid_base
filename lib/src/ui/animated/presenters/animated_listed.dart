import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedListed extends ImplicitlyAnimatedWidget {
  const AnimatedListed({
    super.key,
    required this.listed,
    required this.child,
    super.curve = Easings.emphasized,
    super.duration = Durations.long2,
    this.fadeFirstFraction = 0.0,
    this.direction = Axis.vertical,
    this.axisAlignment = 1.0,
    this.unlistedFraction = 0,
  });

  final bool listed;
  final Widget? child;

  /// 1.0: the child has completely faded out at 50% of the animation
  /// (cannot be seen along other simililarly animated children)
  /// 0.0: the child has fades out during the whole animation
  /// (shares the visibility with any other children fading in-out the same way)
  final double fadeFirstFraction;

  final Axis direction;
  final double axisAlignment;

  final double unlistedFraction;

  @override
  AnimatedWidgetBaseState<AnimatedListed> createState() =>
      _AnimatedListedState();
}

class _AnimatedListedState extends AnimatedWidgetBaseState<AnimatedListed> {
  Tween<double>? _presented;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _presented =
        visitor(
              _presented,
              widget.listed ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final double val = _presented!.evaluate(animation);
    final factor = val.rangeMap(to: (widget.unlistedFraction, 1));

    return IgnorePointer(
      ignoring: !widget.listed,
      child: ClipRect(
        child: Align(
          alignment: switch (widget.direction) {
            Axis.horizontal => Alignment(widget.axisAlignment, 0),
            Axis.vertical => Alignment(0, widget.axisAlignment),
          },
          widthFactor: switch (widget.direction) {
            Axis.horizontal => factor,
            Axis.vertical => 1.0,
          },
          heightFactor: switch (widget.direction) {
            Axis.horizontal => 1.0,
            Axis.vertical => factor,
          },
          child: Opacity(
            opacity: val.rangeMap(
              from: (widget.fadeFirstFraction.rangeMap(to: (0, .5)), 1),
            ),
            child: widget.child,
          ),
        ),
      ),
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

class CustomFractionallyListed extends StatelessWidget {
  const CustomFractionallyListed({
    super.key,
    required this.value,
    required this.child,
    this.axis = Axis.vertical,
    this.axisAlignment = -1,
    this.maxSizeVal = 1,
    this.minOpacityVal = 1 / 2,
  });

  final double axisAlignment;
  final Axis axis;
  final Widget? child;
  final double value;
  final double maxSizeVal;
  final double minOpacityVal;

  @override
  Widget build(BuildContext context) {
    final value = this.value.clamp(0, 1);

    final double sizeFactor = value.rangeMap(from: (0, maxSizeVal));

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
