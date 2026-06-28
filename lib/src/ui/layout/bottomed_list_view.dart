import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class BottomedListView extends StatelessWidget {
  const BottomedListView({
    super.key,
    required this.children,
    required this.bottom,
    this.useSafeArea = true,
    this.physics,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final List<Widget> children;
  final Widget bottom;
  final bool useSafeArea;
  final ScrollPhysics? physics;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      reverse: reverse,
      scrollDirection: scrollDirection,
      slivers: [
        SliverList(delegate: SliverChildListDelegate(children)),
        SliverFillRemaining(
          fillOverscroll: true,
          hasScrollBody: false,
          child: Al.bottomCenter(
            child: SafeArea(
              bottom: useSafeArea,
              top: false,
              left: false,
              right: false,
              child: bottom,
            ),
          ),
        ),
      ],
    );
  }
}
