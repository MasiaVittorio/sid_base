import 'package:flutter/material.dart';

class AnimatedSwitchingIcon extends StatefulWidget {
  final AnimatedIconData firstIcon;
  final AnimatedIconData secondIcon;
  final Animation<double?> progress;
  final Color? color;
  final double? size;
  final TextDirection? textDirection;
  final String? semanticLabel;

  const AnimatedSwitchingIcon({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.progress,
    this.color,
    this.size,
    this.textDirection,
    this.semanticLabel,
  });
  @override
  State<AnimatedSwitchingIcon> createState() => _AnimatedSwitchingIconState();
}

class _AnimatedSwitchingIconState extends State<AnimatedSwitchingIcon> {
  late bool first;

  void listener() {
    if (mounted != true) {
      return;
    }

    double? v = widget.progress.value;
    reactTo(v);
  }

  void reactTo(double? v) {
    if (v == 0.0) {
      setState(() {
        first = true;
      });
    } else if (v == 1.0) {
      setState(() {
        first = false;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedSwitchingIcon oldWidget) {
    if (widget.progress is AlwaysStoppedAnimation) {
      if (oldWidget.progress.value != widget.progress.value) {
        reactTo(widget.progress.value);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    first = true;

    widget.progress.addListener(listener);

    super.initState();
  }

  @override
  void dispose() {
    widget.progress.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: first ? widget.firstIcon : widget.secondIcon,
      progress: first
          ? widget.progress as Animation<double>
          : ReverseAnimation(widget.progress as Animation<double>),
      color: widget.color,
      size: widget.size,
      semanticLabel: widget.semanticLabel,
      textDirection: widget.textDirection,
    );
  }
}
