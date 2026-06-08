import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum ChildrenDisplayMode { free, contained, grouped }

class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.expand = true,
    this.horizontalMargin,
    this.titleHorizontalMargin,
    this.bottom = 0,
    this.spacing = 0,
    this.topMargin,
    this.onTapContainer,
    this.childrenDisplayMode = ChildrenDisplayMode.free,
  });

  const ListSection.contained({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.expand = true,
    this.horizontalMargin,
    this.titleHorizontalMargin,
    this.bottom = 0,
    this.spacing = 0,
    this.topMargin,
    this.onTapContainer,
  }) : childrenDisplayMode = ChildrenDisplayMode.contained;

  const ListSection.grouped({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.expand = true,
    this.horizontalMargin,
    this.titleHorizontalMargin,
    this.bottom = 0,
    this.topMargin,
    this.onTapContainer,
  }) : childrenDisplayMode = ChildrenDisplayMode.grouped,
       spacing = 0; // spacing is not applied in grouped mode

  final List<Widget> children;

  final Widget title;
  final Widget? leading;
  final double? horizontalMargin;
  final Widget? trailing;
  final bool expand;

  final double bottom;
  final double spacing;

  final ChildrenDisplayMode childrenDisplayMode;
  final double? topMargin;
  final double? titleHorizontalMargin;
  final VoidCallback? onTapContainer;

  List<Widget> justTheChildren(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return [
      SectionTitle(
        topMargin: topMargin,
        title: title,
        leading: leading,
        trailing: trailing,
        horizontalMargin: titleHorizontalMargin,
        expand: expand,
      ),
      ...switch (childrenDisplayMode) {
        ChildrenDisplayMode.free => children.modalSeparateWith(
          Space.vertical(spacing),
          apply: spacing > 0,
        ),
        ChildrenDisplayMode.contained => [
          ListCard(
            horizontalMargin: horizontalMargin ?? layout.margin.medium,
            onTap: onTapContainer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children.modalSeparateWith(
                Space.vertical(spacing),
                apply: spacing > 0,
              ),
            ),
          ),
        ],
        ChildrenDisplayMode.grouped => children.groupedCards(
          lastPadding: bottom,
        ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: justTheChildren(context),
    );
  }
}

extension ListSeparatedWith<T> on List<T> {
  List<T> modalSeparateWith(
    T splitter, {
    required bool apply,
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) =>
      apply
          ? <T>[
            if (alsoFirst || alsoFirstAndLast) splitter,
            if (isNotEmpty) first,
            for (int i = 1; i < length; ++i) ...<T>[splitter, this[i]],
            if (alsoLast || alsoFirstAndLast) splitter,
          ]
          : this;
}

extension ListSectionFromChildren on List<Widget> {
  List<Widget> groupedSection(
    BuildContext context, {
    required Widget title,
    Widget? leading,
    double? horizontalMargin,
    Widget? trailing,
    bool expand = true,
    double bottom = 0,
    double? topMargin,
    double? titleHorizontalMargin,
    VoidCallback? onTapContainer,
  }) => ListSection.grouped(
    title: title,
    leading: leading,
    horizontalMargin: horizontalMargin,
    trailing: trailing,
    expand: expand,
    bottom: bottom,
    topMargin: topMargin,
    titleHorizontalMargin: titleHorizontalMargin,
    onTapContainer: onTapContainer,
    children: this,
  ).justTheChildren(context);

  List<Widget> containedSection(
    BuildContext context, {
    required Widget title,
    Widget? leading,
    double? horizontalMargin,
    Widget? trailing,
    bool expand = true,
    double bottom = 0,
    double spacing = 0,
    double? topMargin,
    double? titleHorizontalMargin,
    VoidCallback? onTapContainer,
  }) => ListSection.contained(
    title: title,
    leading: leading,
    horizontalMargin: horizontalMargin,
    trailing: trailing,
    expand: expand,
    bottom: bottom,
    spacing: spacing,
    topMargin: topMargin,
    titleHorizontalMargin: titleHorizontalMargin,
    onTapContainer: onTapContainer,
    children: this,
  ).justTheChildren(context);

  List<Widget> sectioned(
    BuildContext context, {
    required Widget title,
    Widget? leading,
    double? horizontalMargin,
    Widget? trailing,
    bool expand = true,
    double bottom = 0,
    double spacing = 0,
    ChildrenDisplayMode childrenDisplayMode = ChildrenDisplayMode.free,
    double? topMargin,
    double? titleHorizontalMargin,
    VoidCallback? onTapContainer,
  }) => ListSection(
    title: title,
    leading: leading,
    horizontalMargin: horizontalMargin,
    trailing: trailing,
    expand: expand,
    bottom: bottom,
    spacing: spacing,
    childrenDisplayMode: childrenDisplayMode,
    topMargin: topMargin,
    titleHorizontalMargin: titleHorizontalMargin,
    onTapContainer: onTapContainer,
    children: this,
  ).justTheChildren(context);
}
