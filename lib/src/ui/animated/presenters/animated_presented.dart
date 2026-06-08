// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum PresentMode { scale, slide }

class AnimatedPresented extends ImplicitlyAnimatedWidget {
  const AnimatedPresented({
    super.key,
    required this.presented,
    this.child,
    this.offScale = 0.8,
    Curve? curve,
    required super.duration,
    this.presentMode = PresentMode.scale,
    this.slideOffset = const Offset(0, 200),
    this.fadeFirstFraction = 0.0,
  }) : super(curve: curve ?? Curves.linear);

  final double offScale;
  final bool presented;
  final Widget? child;
  final PresentMode presentMode;
  final Offset slideOffset;

  /// 1.0: the child has completely faded out at 50% of the animation
  /// (cannot be seen along other simililarly animated children)
  /// 0.0: the child has fades out during the whole animation
  /// (shares the visibility with any other children fading in-out the same way)
  final double fadeFirstFraction;

  @override
  AnimatedWidgetBaseState<AnimatedPresented> createState() =>
      _DivisionAnimateState();
}

class _DivisionAnimateState extends AnimatedWidgetBaseState<AnimatedPresented> {
  Tween<double>? _presented;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _presented =
        visitor(
              _presented,
              widget.presented ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final double val = _presented!.evaluate(animation);
    return IgnorePointer(
      ignoring: !widget.presented,
      child:
          widget.presentMode == PresentMode.scale
              ? Transform.scale(
                scale: val.rangeMap(to: (widget.offScale, 1)),
                alignment: Alignment.center,
                child: Opacity(opacity: val, child: widget.child),
              )
              : Transform.translate(
                offset: Offset(
                  Curves.easeInOut
                      .transform(val)
                      .rangeMap(to: (widget.slideOffset.dx, 0)),
                  Curves.easeInOut
                      .transform(val)
                      .rangeMap(to: (widget.slideOffset.dy, 0)),
                ),
                child: Opacity(
                  opacity: val.rangeMap(
                    from: (widget.fadeFirstFraction.rangeMap(to: (0, .5)), 1),
                  ),
                  child: widget.child,
                ),
              ),
    );
  }
}
