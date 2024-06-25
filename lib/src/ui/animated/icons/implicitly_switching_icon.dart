import 'package:flutter/material.dart';

import 'animated_switching_icon.dart';

class ImplicitlySwitchingIcon extends ImplicitlyAnimatedWidget {
  const ImplicitlySwitchingIcon({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.progress,
    this.color,
    this.size,
    this.semanticLabel,
    this.textDirection,
    Curve? curve,
    required super.duration,
  }) : super(
          curve: curve ?? Curves.linear,
        );

  final AnimatedIconData firstIcon;
  final AnimatedIconData secondIcon;
  final double progress;

  final Color? color;
  final double? size;
  final TextDirection? textDirection;
  final String? semanticLabel;

  @override
  AnimatedWidgetBaseState<ImplicitlySwitchingIcon> createState() => _ImplicitlySwitchingIconState();
}

class _ImplicitlySwitchingIconState extends AnimatedWidgetBaseState<ImplicitlySwitchingIcon> {
  Tween<double>? _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(_tween, widget.progress, (dynamic value) => Tween<double>(begin: value))
        as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchingIcon(
      progress: AlwaysStoppedAnimation<double>(_tween!.evaluate(animation)),
      firstIcon: widget.firstIcon,
      secondIcon: widget.secondIcon,
      color: widget.color,
      size: widget.size,
      semanticLabel: widget.semanticLabel,
      textDirection: widget.textDirection,
    );
  }
}
