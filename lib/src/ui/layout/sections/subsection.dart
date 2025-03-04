import 'package:flutter/material.dart';

class SubSection extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius borderRadius;
  final bool color;
  final Color? overrideColor;
  final DecorationImage? image;

  const SubSection.withoutMargin(
    this.children, {
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onTap,
    this.onLongPress,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.borderRadius = borderRadiusDefault,
    this.color = true,
    this.overrideColor,
    this.image,
  }) : margin = EdgeInsets.zero;

  const SubSection(
    this.children, {
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.margin = const EdgeInsets.symmetric(horizontal: 10),
    this.onTap,
    this.onLongPress,
    this.borderRadius = borderRadiusDefault,
    this.color = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.overrideColor,
    this.image,
  });

  const SubSection.stretch(
    this.children, {
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 10),
    this.onTap,
    this.onLongPress,
    this.borderRadius = borderRadiusDefault,
    this.color = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.overrideColor,
    this.image,
  }) : crossAxisAlignment = CrossAxisAlignment.stretch;

  static Color getColor(ThemeData theme) =>
      theme.scaffoldBackgroundColor.withValues(alpha: 0.7);

  static const borderRadiusDefault = BorderRadius.all(Radius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final background = getColor(theme);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: overrideColor ?? (color ? background : null),
        borderRadius: borderRadius,
        image: image,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: children,
          ),
        ),
      ),
    );
  }
}
