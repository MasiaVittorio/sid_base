import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ViewPage<T> {
  final Widget child;
  final T value;

  const ViewPage({required this.child, required this.value});
}

class AnimatedPagedView<T> extends StatelessWidget {
  const AnimatedPagedView({
    super.key,
    required this.value,
    required this.pages,
    this.direction = Axis.horizontal,
    this.fractionalOffset = 0.9,
    this.opacityOverlap = 0.1,
    this.durationMultiplier = 1,
  });

  final T value;
  final List<ViewPage<T>> pages;
  final Axis direction;
  final double fractionalOffset;
  final double opacityOverlap;

  // durations are different for enter and exit animations, and decided internally to be Durations.medium4 and Durations.short4, but this multiplier can be used to make both of them faster or slower while keeping the same ratio between them
  final double durationMultiplier;

  @override
  Widget build(BuildContext context) {
    final int index = pages.indexWhere((p) => p.value == value);

    return Stack(
      children: <Widget>[
        for (int i = 0; i < pages.length; i++)
          if (pages[i] case ViewPage<T> page)
            AnimatedPage(
              key: ValueKey(page.value),
              direction: direction,
              fractionalOffset: fractionalOffset,
              opacityOverlap: opacityOverlap,
              durationMultiplier: durationMultiplier,
              state: switch (i - index) {
                < 0 => AnimatedPageState.early,
                > 0 => AnimatedPageState.late,
                _ => AnimatedPageState.center,
              },
              child: page.child,
            ),
      ],
    );
  }
}

enum AnimatedPageState { early, center, late }

class AnimatedPage extends StatefulWidget {
  const AnimatedPage({
    super.key,
    required this.child,
    required this.state,
    this.direction = Axis.horizontal,
    this.fractionalOffset = 0.9,
    this.opacityOverlap = 0.1,
    this.durationMultiplier = 1,
  });

  final Widget child;
  final Axis direction;
  final AnimatedPageState state;
  final double fractionalOffset;
  final double opacityOverlap;

  // durations are different for enter and exit animations, and decided internally to be Durations.medium4 and Durations.short4, but this multiplier can be used to make both of them faster or slower while keeping the same ratio between them
  final double durationMultiplier;

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with TickerProviderStateMixin {
  late AnimationController slideController;
  late AnimationController opacityController;

  @override
  void initState() {
    super.initState();
    slideController = AnimationController(
      vsync: this,
      lowerBound: -1,
      upperBound: 1,
      value: switch (widget.state) {
        AnimatedPageState.early => -1,
        AnimatedPageState.center => 0,
        AnimatedPageState.late => 1,
      },
    );
    opacityController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      value: switch (widget.state) {
        AnimatedPageState.center => 1,
        _ => 0,
      },
    );
  }

  @override
  void dispose() {
    slideController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    switch (widget.state) {
      case AnimatedPageState.early:
        animateSlide(-1);
        animateOpacity(0);
        return;
      case AnimatedPageState.center:
        animateSlide(0);
        animateOpacity(1);
        return;
      case AnimatedPageState.late:
        animateSlide(1);
        animateOpacity(0);
        return;
    }
  }

  Duration get exitDuration => Durations.short4 * widget.durationMultiplier;
  Duration get enterDuration => Durations.medium4 * widget.durationMultiplier;
  static const exitCurve = Easings.emphasizedAccelerate;
  static const enterCurve = Easings.emphasizedDecelerate;

  int _id = 0;
  void animateOpacity(double target) async {
    ++_id;

    if (opacityController.value == target && !opacityController.isAnimating) {
      // could be at zero but nonetheles have an animation that started towards one, in which case we should not cancel this
      return;
    }
    final exitSlide = exitDuration.inMicroseconds;
    final enterSlide = enterDuration.inMicroseconds;

    final int exitOpacityZeroOverlap =
        exitSlide * enterSlide ~/ (exitSlide + enterSlide);

    final int exitOpacity = widget.opacityOverlap
        .rangeMap(from: (0, 1), to: (exitOpacityZeroOverlap, exitSlide))
        .round();

    final int enterOpacityZeroOverlap = enterSlide - exitOpacityZeroOverlap;

    final int enterOpacity = widget.opacityOverlap
        .rangeMap(from: (0, 1), to: (enterOpacityZeroOverlap, enterSlide))
        .round();
    final int currentId = _id + 0;
    if (target == 1) {
      await Future.delayed(Duration(microseconds: enterSlide - enterOpacity));
    }
    // if another animation has started, cancel this one
    if (currentId != _id) {
      return;
    }
    if (opacityController.value == target) {
      if (!opacityController.isAnimating) {
        // could be at zero but nonetheless have an animation that started towards one, in which case we are fucked
        return;
      }
    }

    opacityController.animateTo(
      target,
      curve: Curves.linear,
      duration: Duration(
        microseconds: target == 1 ? enterOpacity : exitOpacity,
      ),
    );
  }

  void animateSlide(double target) async {
    if (slideController.value == target) return;
    slideController.animateTo(
      target,
      curve: target == 0 ? enterCurve : exitCurve,
      duration: target == 0 ? enterDuration : exitDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideController,
      child: AnimatedBuilder(
        animation: opacityController,
        child: widget.child,
        builder: (context, child) {
          return IgnorePointer(
            ignoring: opacityController.value < 0.9,
            child: Opacity(opacity: opacityController.value, child: child),
          );
        },
      ),
      builder: (context, child) {
        final double slideValue =
            slideController.value * widget.fractionalOffset;
        return FractionalTranslation(
          translation: switch (widget.direction) {
            Axis.horizontal => Offset(slideValue, 0),
            Axis.vertical => Offset(0, slideValue),
          },
          child: child,
        );
      },
    );
  }
}
