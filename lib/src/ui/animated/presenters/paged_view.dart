import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ViewPage<T> {
  final Widget child;
  final T value;

  ViewPage({required this.child, required this.value});
}

class AnimatedPagedView<T> extends StatelessWidget {
  const AnimatedPagedView({
    super.key,
    required this.value,
    required this.pages,
  });

  final T value;
  final List<ViewPage<T>> pages;

  @override
  Widget build(BuildContext context) {
    final int index = pages.indexWhere((p) => p.value == value);

    return Stack(
      children: <Widget>[
        for (int i = 0; i < pages.length; i++)
          if (pages[i] case ViewPage<T> page)
            DirectionalAnimatedPresented(
              value: (i - index).toDouble(),
              child: page.child,
            ),
      ],
    );
  }
}
