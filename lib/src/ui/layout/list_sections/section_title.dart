import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.expand = true,
    this.horizontalMargin,
    this.titleVerticalMargin,
    this.topMargin,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final bool expand;
  final double? horizontalMargin;
  final double? topMargin;
  final double? titleVerticalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final foregroundColor = theme.colorScheme.primary;

    final title = Pad(
      vertical: titleVerticalMargin ?? layout.margin.tiny,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.merge(
          context.theme.textTheme.labelLarge!.copyWith(color: foregroundColor),
        ),
        textAlign: TextAlign.start,
        child: this.title,
      ),
    );

    return Pad(
      top: topMargin ?? (layout.margin.medium - layout.margin.tiny),
      left: horizontalMargin ?? context.theme.layout.margin.large,
      right:
          ((horizontalMargin ?? context.theme.layout.margin.large) -
                  (trailing is ButtonStyleButton ? 8 : 0))
              .clamp(0, double.infinity),
      bottom: leading != null || trailing != null ? layout.spacing.small : 0,
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (leading case Widget leading)
            Material(
              borderRadius: BorderRadius.circular(9999),
              color: theme.colorScheme.surfaceContainer,
              child: Pad(
                all: 8,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                  child: Center(
                    child: IconTheme(
                      data: IconTheme.of(
                        context,
                      ).copyWith(color: foregroundColor),
                      child: leading,
                    ),
                  ),
                ),
              ),
            ),
          if (expand) Expanded(child: title) else title,
          if (trailing case Widget trailing)
            Theme(
              data: theme.copyWith(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: trailing,
            ),
        ].separateWith(Space.horizontal(layout.spacing.small)),
      ),
    );
  }
}
