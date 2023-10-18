import 'package:flutter/material.dart';// hide Easing;
import 'package:sid_base/sid_base.dart';

//only one animated icon, different from animated switching icon that accepts a forward animated icon and a backward one

class ImplicitlyAnimatedIcon extends ImplicitlyAnimatedWidget {
  const ImplicitlyAnimatedIcon({
    super.key,
    required this.icon,
    required this.progress,
    this.color,
    this.size,
    super.curve = Easing.standard,
    super.duration = Motion.short4,
  });

  final AnimatedIconData icon;
  final double progress;
  final Color? color;
  final double? size;
  @override
  AnimatedWidgetBaseState<ImplicitlyAnimatedIcon> createState() =>
      _ImplicitlyAnimatedIconState();
}

class _ImplicitlyAnimatedIconState
    extends AnimatedWidgetBaseState<ImplicitlyAnimatedIcon> {
  Tween<double>? _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(_tween, widget.progress,
        (dynamic value) => Tween<double>(begin: value)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      progress: AlwaysStoppedAnimation<double>(_tween!.evaluate(animation)),
      icon: widget.icon,
      color: widget.color,
      size: widget.size,
    );
  }
}
