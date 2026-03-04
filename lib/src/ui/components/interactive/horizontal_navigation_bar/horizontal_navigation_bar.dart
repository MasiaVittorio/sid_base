import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

import 'custom_row.dart';
import 'multi_animated_value_builder.dart';

class HorizontalNavigationItem<T> {
  final T value;
  final Widget label;
  final Widget selectedIcon;
  final Widget? unselectedIcon;

  const HorizontalNavigationItem({
    required this.value,
    required this.label,
    required this.selectedIcon,
    this.unselectedIcon,
  });
}

class HorizontalNavigationBar<T> extends StatelessWidget {
  const HorizontalNavigationBar({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.height = kToolbarHeight,
    this.extraBottomPadding = 0,
    this.extraTopPadding = 0,
    this.barBackgroundColor,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.itemSelectedBackgroundColor,
    this.horizontalMargin,

    // a bit shorter than the default for the emphasized curve, to make it feel more responsive
    this.duration = Durations.long1,
    this.curve = Easings.emphasized,
  });

  final List<HorizontalNavigationItem<T>> items;
  final T value;
  final ValueChanged<T> onChanged;
  final double height;
  final double extraBottomPadding;
  final double extraTopPadding;
  final Color? barBackgroundColor;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? itemSelectedBackgroundColor;
  final double? horizontalMargin;

  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final int n = items.length;

    final Color barBackgroundColor =
        this.barBackgroundColor ?? theme.colorScheme.surface;
    final Color foregroundColor =
        this.foregroundColor ?? theme.colorScheme.onSurface;
    final Color selectedForegroundColor =
        this.selectedForegroundColor ?? theme.colorScheme.primary;
    final Color itemSelectedBackgroundColor =
        this.itemSelectedBackgroundColor ?? theme.colorScheme.surfaceContainer;

    final labels = [
      for (final item in items)
        _Label(selectedForegroundColor: selectedForegroundColor, item: item),
    ];

    final icons = [
      for (final item in items)
        _Icon(
          item: item,
          isSelected: item.value == value,
          selectedForegroundColor: selectedForegroundColor,
          foregroundColor: foregroundColor,
        ),
    ];

    final double selectedItemExpansion = switch (n) {
      <= 2 => 0.6,
      3 => 0.5,
      _ => 0,
    };

    final bar = MultiAnimatedValueBuilder(
      duration: duration,
      curve: curve,
      values: [
        for (int i = 0; i < items.length; i++)
          if (items[i] case HorizontalNavigationItem<T> item)
            if (item.value == value case bool sel) sel ? 1 : 0,
      ],
      builder: (context, values) {
        return CustomRow(
          minHorizontalMargin: horizontalMargin ?? layout.margin.large,
          expansions: [
            for (final value in values)
              value.rangeMap(to: (1, selectedItemExpansion)),
          ],
          children: [
            for (int i = 0; i < items.length; i++)
              InkResponse(
                highlightColor: Colors.transparent,
                onTap: () => onChanged(items[i].value),
                containedInkWell: false,
                child: Center(
                  child: _NavigationTile(
                    listedValue: values[i],
                    icon: icons[i],
                    label: labels[i],
                    onTap: () => onChanged(items[i].value),
                    itemSelectedBackgroundColor: itemSelectedBackgroundColor,
                    barBackgroundColor: barBackgroundColor,
                    height: height,
                  ),
                ),
              ),
          ],
        );
      },
    );

    return Material(
      color: barBackgroundColor,
      child: Pad(
        top: extraTopPadding,
        bottom: context.safe.bottom + extraBottomPadding,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: SizedBox(height: height, child: bar),
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.itemSelectedBackgroundColor,
    required this.barBackgroundColor,
    required this.height,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.listedValue,
  });

  final double listedValue;
  final _Label label;
  final Color itemSelectedBackgroundColor;

  final Color barBackgroundColor;
  final double height;

  final VoidCallback onTap;

  final _Icon icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final Widget tile = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        CustomFractionallyListed(
          value: listedValue,
          axis: Axis.horizontal,
          minOpacityVal: 0.6,
          child: label,
        ),
      ],
    );

    if (itemSelectedBackgroundColor == barBackgroundColor) {
      return tile;
    }
    return Material(
      borderRadius: BorderRadius.circular(height),
      color: Color.lerp(
        itemSelectedBackgroundColor.withValues(alpha: 0),
        itemSelectedBackgroundColor,
        listedValue,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(height),
        onTap: onTap,
        highlightColor: Colors.transparent,
        child: Pad(
          vertical: theme.layout.padding.smaller,
          horizontal: layout.padding.small,
          child: tile,
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.item,
    required this.isSelected,
    required this.selectedForegroundColor,
    required this.foregroundColor,
  });

  final HorizontalNavigationItem<Object?> item;
  final bool isSelected;
  final Color selectedForegroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final standardExit = Motion.exitScreenStandard;
    final standardEnter = Motion.enterScreenStandard;
    final standardStay = Motion.beginAndEndOnScreenStandard;

    return Pad(
      all: layout.padding.tiny,
      child: switch (item.unselectedIcon) {
        null => AnimatedColorBuilder(
          value: isSelected ? selectedForegroundColor : foregroundColor,
          curve: standardStay.curve,
          duration: standardStay.duration,
          child: item.selectedIcon,
          builder: (context, value, child) {
            return _ApplyColorOnTextAndIcons(color: value, child: child!);
          },
        ),

        Widget unselectedIcon => Stack(
          children: [
            AnimatedOpacity(
              opacity: isSelected ? 0 : 1,
              duration:
                  isSelected ? standardExit.duration : standardEnter.duration,
              curve: isSelected ? standardExit.curve : standardEnter.curve,
              child: _ApplyColorOnTextAndIcons(
                color: foregroundColor,
                child: unselectedIcon,
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration:
                  isSelected ? standardEnter.duration : standardEnter.duration,
              curve: isSelected ? standardEnter.curve : standardEnter.curve,
              child: _ApplyColorOnTextAndIcons(
                color: selectedForegroundColor,
                child: item.selectedIcon,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.selectedForegroundColor, required this.item});

  final Color selectedForegroundColor;
  final HorizontalNavigationItem<Object?> item;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Pad(
      left: layout.spacing.small,
      right: layout.padding.small,
      child: _ApplyColorOnTextAndIcons(
        color: selectedForegroundColor,
        child: item.label,
      ),
    );
  }
}

class _ApplyColorOnTextAndIcons extends StatelessWidget {
  const _ApplyColorOnTextAndIcons({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconTheme.of(context).copyWith(color: color),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style
            .merge(context.theme.textTheme.labelMedium)
            .copyWith(color: color),
        child: child,
      ),
    );
  }
}
