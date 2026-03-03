import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.horizontalMargin = 0,
    this.shape,
    this.isSelected = false,
    this.clip = Clip.antiAlias,
    this.borderRadius,
    this.backgroundColor,
  });

  final double horizontalMargin;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ShapeBorder? shape;
  final Clip clip;
  final bool isSelected;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final scheme = theme.colorScheme;
    return Pad(
      horizontal: horizontalMargin,
      child: Material(
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius:
                  borderRadius ??
                  BorderRadius.circular(theme.layout.radius.medium),
              side:
                  isSelected
                      ? BorderSide(color: scheme.primary)
                      : BorderSide.none,
            ),
        color:
            backgroundColor ??
            (isSelected
                ? scheme.surfaceContainerHighest
                : scheme.surfaceContainerHigh),
        clipBehavior: clip,
        child:
            onTap == null && onLongPress == null
                ? child
                : InkWell(onTap: onTap, onLongPress: onLongPress, child: child),
      ),
    );
  }
}
