import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MultiAnimatedValueBuilder extends ImplicitlyAnimatedWidget {
  const MultiAnimatedValueBuilder({
    super.key,
    required this.values,
    required this.builder,
    super.duration = Durations.medium2,
    super.curve = Easings.standard,
  });

  final List<double> values;
  final Widget Function(BuildContext context, List<double> values) builder;

  @override
  AnimatedWidgetBaseState<MultiAnimatedValueBuilder> createState() =>
      _MultiAnimatedValueBuilderState();
}

class _MultiAnimatedValueBuilderState
    extends AnimatedWidgetBaseState<MultiAnimatedValueBuilder> {
  List<Tween<double>> tweens = [];

  @override
  void didUpdateWidget(covariant MultiAnimatedValueBuilder oldWidget) {
    if (widget.values.length != oldWidget.values.length) {
      tweens.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    for (int i = 0; i < widget.values.length; i++) {
      if (tweens.length <= i) {
        tweens.add(
          visitor(
                null,
                widget.values[i],
                (value) => Tween<double>(begin: value),
              )
              as Tween<double>,
        );
      } else {
        tweens[i] =
            visitor(
                  tweens[i],
                  widget.values[i],
                  (value) => Tween<double>(begin: value),
                )
                as Tween<double>;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, [
      for (int i = 0; i < widget.values.length; i++)
        if (tweens.length > i)
          tweens[i].evaluate(animation)
        else
          widget.values[i],
    ]);
  }
}
