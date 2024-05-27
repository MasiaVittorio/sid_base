// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';


class OpenFab extends StatelessWidget {
  const OpenFab({
    super.key,
    this.backgroundColor,
    required this.extended,
    required this.label,
    required this.icon,
    this.beforeOpening,
    this.onClosed,
    this.openBuilder,
    this.labelSize,
    this.useRootNavigator = false,
    this.margin = const EdgeInsets.all(20),
  });

  final Color? backgroundColor;
  final bool extended;
  final Widget label;
  final Widget icon;
  final double? labelSize;
  final EdgeInsets margin;
  final VoidCallback? onClosed;
  final Future<void> Function()? beforeOpening;
  final bool useRootNavigator;

  final Widget Function(BuildContext _, VoidCallback close)? openBuilder;

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final closedColor = backgroundColor ?? theme.colorScheme.secondaryContainer;
    final oc = onClosed;
    return Padding(
      padding: margin,
      child: Row(
        children: [
          const Spacer(),
          OpenContainer(
            useRootNavigator: useRootNavigator,
            openElevation: 0,
            closedElevation: 0,
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 300),
            closedColor: closedColor,
            middleColor: theme.colorScheme.background,
            openColor: theme.colorScheme.background,
            closedShape: const RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            tappable: false,
            onClosed: oc == null ? null : (data) => oc(),
            closedBuilder: (_, open) => CustomFab(
              backgroundColor: closedColor,
              icon: icon,
              extended: extended,
              label: label,
              onTap: () async {
                context.unfocus();
                final bf = beforeOpening;
                if (bf != null) {
                  await bf();
                }
                open();
              },
              labelSize: labelSize ?? CustomFab.defaultLabelSize,
            ),
            openBuilder: openBuilder ??
                ((_, close) => InkWell(
                      onTap: close,
                      child: const SizedBox.expand(),
                    )),
          ),
        ],
      ),
    );
  }
}

class CustomFab extends StatelessWidget {
  const CustomFab({
    super.key,
    this.backgroundColor,
    this.icon,
    required this.extended,
    required this.label,
    required this.onTap,
    this.borderRadius,
    this.labelSize = defaultLabelSize,
  });

  static const double defaultLabelSize = 70.0;

  final Color? backgroundColor;
  final Widget? icon;
  final bool extended;
  final Widget label;
  final BorderRadius? borderRadius;

  final VoidCallback onTap;

  static const double fabSize = 56;
  final double labelSize;
  double get maxWidth => labelSize + fabSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);
    return Material(
      color: backgroundColor ?? theme.colorScheme.secondaryContainer,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: content(theme, defaultTextStyle),
      ),
    );
  }

  Widget content(ThemeData theme, DefaultTextStyle defaultTextStyle) {
    final Widget? icon = this.icon;
    if (icon != null) {
      return iconAndLabel(icon, theme, defaultTextStyle);
    }
    return onlyLabel(theme, defaultTextStyle);
  }

  Row iconAndLabel(Widget icon, ThemeData theme, DefaultTextStyle defaultTextStyle) {
    return Row(
      children: [
        SizedBox.square(
          dimension: fabSize,
          child: Center(child: icon),
        ),
        AnimatedListed(
          listed: extended,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          axis: Axis.horizontal,
          child: SizedBox(
            width: labelSize,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: buildLabel(theme, defaultTextStyle),
            ),
          ),
        ),
      ],
    );
  }

  DefaultTextStyle buildLabel(ThemeData theme, DefaultTextStyle defaultTextStyle) {
    return DefaultTextStyle(
      style: theme.textTheme.labelLarge ?? defaultTextStyle.style,
      child: label,
    );
  }

  Widget onlyLabel(ThemeData theme, DefaultTextStyle defaultTextStyle) {
    return SizedBox(
      height: fabSize,
      width: fabSize + labelSize,
      child: Center(
        child: buildLabel(theme, defaultTextStyle),
      ),
    );
  }
}
