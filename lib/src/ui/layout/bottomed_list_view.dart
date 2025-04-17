import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class BottomedListView extends StatelessWidget {
  const BottomedListView({
    super.key,
    required this.children,
    required this.bottom,
    required this.useSafeArea,
    this.physics,
  });

  final List<Widget> children;
  final Widget bottom;
  final bool useSafeArea;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
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
