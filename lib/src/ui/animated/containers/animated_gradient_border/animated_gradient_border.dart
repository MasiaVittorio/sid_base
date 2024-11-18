import 'package:flutter/material.dart';

import 'aligned_gradient_and_shadows.dart';
import 'border_cutout_clip.dart';

class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.colorA,
    required this.colorB,
    this.radius = const Radius.circular(16),
    this.thickness = 3,
    this.duration = const Duration(seconds: 3),
  });

  final Widget child;
  final Radius radius;
  final double thickness;
  final Color colorA;
  final Color colorB;
  final Duration duration;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Alignment> cornerA;
  late Animation<Alignment> cornerB;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    cornerA = TweenSequence([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
    ]).animate(controller);
    cornerB = TweenSequence([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
    ]).animate(controller);

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BorderCutoutClip(
            thickness: widget.thickness,
            radius: widget.radius,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => AlignedGradientAndShadows(
                cornerA: cornerA.value,
                cornerB: cornerB.value,
                radius: widget.radius,
                colorA: widget.colorA,
                colorB: widget.colorB,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
