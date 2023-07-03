import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ResponsiveScrollStack extends StatefulWidget {
  const ResponsiveScrollStack({
    Key? key,
    required this.children,
    this.threshold = 0,
    this.thresholdOverlay,
    this.userDirectionOverlay,
    this.atEndEdgeOverlay,
    this.topPadding,
    this.bottomPadding,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.ease,
    this.physics = const BouncingScrollPhysics(),
    this.initialAtEnd,
    this.bubbleUpNotifications = false,
  }) : super(key: key);

  final bool bubbleUpNotifications;

  final List<Widget> children;

  final double threshold;
  final Widget Function(
    BuildContext _,
    bool overThreshold,
  )? thresholdOverlay;

  final Widget Function(
    BuildContext _,
    bool? atEndEdge,
  )? atEndEdgeOverlay;

  final Widget Function(
    BuildContext _,
    ScrollDirection? userDirection,
  )? userDirectionOverlay;

  final double Function(bool overThreshold, bool? atEndEdge, ScrollDirection? userDirection)?
      topPadding;
  final double Function(bool overThreshold, bool? atEndEdge, ScrollDirection? userDirection)?
      bottomPadding;

  final Duration duration;
  final Curve curve;
  final ScrollPhysics? physics;
  final bool? initialAtEnd;

  @override
  State<ResponsiveScrollStack> createState() => _ResponsiveScrollStackState();
}

class _ResponsiveScrollStackState extends State<ResponsiveScrollStack> {
  late Reactive<bool> overThreshold;
  // if null: not scrollable at all
  late Reactive<bool?> atEndEdge;
  late Reactive<ScrollDirection?> userDirection;
  late ScrollController controller;
  bool alreadyScrolled = false;
  bool notScrollableAtAll = false;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    overThreshold = false.createReactive;
    atEndEdge = Reactive(widget.initialAtEnd ?? true);
    userDirection = Reactive<ScrollDirection?>(null);
    checkScrollable();
  }

  @override
  void dispose() {
    controller.dispose();
    overThreshold.dispose();
    userDirection.dispose();
    atEndEdge.dispose();
    super.dispose();
  }

  void checkScrollable() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      if (!alreadyScrolled) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            if (controller.hasClients) {
              if (controller.position.maxScrollExtent == 0) {
                atEndEdge.update(null);
              } else {
                atEndEdge.update(controller.position.pixels >= controller.position.maxScrollExtent);
              }
            } else {
              atEndEdge.update(null);
            }
          }
        });
      }
    }
  }

  static const extraRealEstate = 100.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: -extraRealEstate,
          child: list(),
        ),
        if (widget.atEndEdgeOverlay != null)
          Positioned.fill(
              child: atEndEdge.build(
            (context, val) => widget.atEndEdgeOverlay!(context, val),
          )),
        if (widget.thresholdOverlay != null)
          Positioned.fill(
              child: overThreshold.build(
            (context, val) => widget.thresholdOverlay!(context, val),
          )),
        if (widget.userDirectionOverlay != null)
          Positioned.fill(
              child: userDirection.build(
            (context, val) => widget.userDirectionOverlay!(context, val),
          )),
      ],
    );
  }

  Widget buildPadding(double Function(bool over, bool? end, ScrollDirection? direction) padding) =>
      Reactive.build3<bool, bool?, ScrollDirection?>(
        overThreshold,
        atEndEdge,
        userDirection,
        builder: (_, over, end, direction) => AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          height: padding(over, end, direction),
          width: double.infinity,
        ),
      );

  NotificationListener<Notification> list() {
    return NotificationListener<ScrollNotification>(
      onNotification: reactToScrollNotification,
      child: SingleChildScrollView(
        controller: controller,
        physics: widget.physics,
        child: NotificationListener(
          // to ignore scroll notifications
          // from other scrollviews in the children
          onNotification: ignoreScrollNotification,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.topPadding != null)
                buildPadding(
                  (over, end, direction) =>
                      widget.topPadding!(over, end, direction) + extraRealEstate,
                )
              else
                const Space.vertical(extraRealEstate),
              ...widget.children,
              if (widget.bottomPadding != null) buildPadding(widget.bottomPadding!),
            ],
          ),
        ),
      ),
    );
  }

  bool ignoreScrollNotification(ScrollNotification notification) {
    return true;
  }

  bool reactToScrollNotification(ScrollNotification notif) {
    if (!alreadyScrolled) {
      alreadyScrolled = true;
    }
    if (notif is UserScrollNotification) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        userDirection.update(notif.direction);
      });
      return !widget.bubbleUpNotifications;
    }
    if (notif is ScrollUpdateNotification) {
      final metrics = notif.metrics;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        overThreshold.update(notif.metrics.pixels > widget.threshold);
        atEndEdge.update(metrics.pixels >= metrics.maxScrollExtent);
      });
    }
    return false;
  }
}
