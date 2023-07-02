import 'package:animations/animations.dart';
import 'package:sid_base/sid_base.dart';
import 'package:flutter/material.dart';

abstract class ValueTile<T> extends StatelessWidget {

  const ValueTile({super.key});

  Widget updater(ValueBuilder<T> builder);

  bool get useRootNavigatorForDetail => false;

  Widget _builder(BuildContext context, T value) {
    final theme = context.theme;
    return OpenContainer(
      closedColor: theme.colorScheme.surface,
      openColor: theme.colorScheme.surface,
      middleColor: theme.colorScheme.surface,
      openElevation: 0,
      closedElevation: 0,

      useRootNavigator: useRootNavigatorForDetail,

      tappable: false,

      closedBuilder: (context, action) => tile(action, value),
      openBuilder: (context, action) => detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return updater(_builder);
  }

  Widget get detail;

  ListTile tile(VoidCallback open, T value) {
    return ListTile(
      onTap: open,
      title: title(value),
      subtitle: subtitle(value),
    );
  }

  Widget? subtitle(T value);
  Widget title(T value) => Text(name(value));
  String name(T value);

}