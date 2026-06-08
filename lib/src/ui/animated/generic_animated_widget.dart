import 'package:flutter/material.dart';

class GenericAnimatedBuilder extends ImplicitlyAnimatedWidget {
  const GenericAnimatedBuilder({
    super.key,
    required this.value,
    required this.builder,
    super.curve = Curves.ease,
    super.duration = const Duration(milliseconds: 250),
    this.animate = true,
    this.child,
  });

  final double value;
  final bool animate;
  final Widget? child;
  final Widget Function(BuildContext context, double value, Widget? child)
  builder;

  @override
  AnimatedWidgetBaseState<GenericAnimatedBuilder> createState() =>
      _GenericAnimatedBuilderState();
}

class _GenericAnimatedBuilderState
    extends AnimatedWidgetBaseState<GenericAnimatedBuilder> {
  Tween<double>? _double;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _double =
        visitor(
              _double,
              widget.value,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
    if (!widget.animate) {
      _double = Tween<double>(begin: widget.value, end: widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final val = _double!.evaluate(animation);
    return widget.builder(context, val, widget.child);
  }
}

class AnimatedColorBuilder extends ImplicitlyAnimatedWidget {
  const AnimatedColorBuilder({
    super.key,
    required this.value,
    required this.builder,
    super.curve = Curves.ease,
    super.duration = const Duration(milliseconds: 250),
    this.animate = true,
    this.child,
  });

  final Color value;
  final bool animate;
  final Widget? child;
  final Widget Function(BuildContext context, Color value, Widget? child)
  builder;

  @override
  AnimatedWidgetBaseState<AnimatedColorBuilder> createState() =>
      _AnimatedColorBuilderState();
}

class _AnimatedColorBuilderState
    extends AnimatedWidgetBaseState<AnimatedColorBuilder> {
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color =
        visitor(
              _color,
              widget.value,
              (dynamic value) => ColorTween(begin: value),
            )
            as ColorTween;
    if (!widget.animate) {
      _color = ColorTween(begin: widget.value, end: widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _color!.evaluate(animation)!, widget.child);
  }
}
