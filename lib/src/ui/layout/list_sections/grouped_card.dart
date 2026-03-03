import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class GroupedCard extends StatelessWidget {
  const GroupedCard({
    super.key,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    this.horizontalMargin,
    this.overrideLastPadding,
    this.overrideColor,
  });

  final bool isFirst;
  final bool isLast;
  final Widget child;
  final double? horizontalMargin;
  final double? overrideLastPadding;
  final Color? overrideColor;

  @override
  Widget build(BuildContext context) {
    final layout = context.theme.layout;
    return Pad(
      horizontal: horizontalMargin ?? layout.margin.medium,
      bottom: bottomMargin(
        layout,
        isLast: isLast,
        overrideLastPadding: overrideLastPadding,
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius(layout, isFirst: isFirst, isLast: isLast),
        color: overrideColor ?? context.theme.colorScheme.surfaceContainerHigh,
        child: child,
      ),
    );
  }

  static double bottomMargin(
    Layout layout, {
    required bool isLast,
    double? overrideLastPadding,
  }) =>
      isLast
          ? (overrideLastPadding ?? layout.margin.medium)
          : layout.spacing.tiny;

  static BorderRadius borderRadius(
    Layout layout, {
    required bool isFirst,
    required bool isLast,
  }) {
    return BorderRadius.vertical(
      top:
          isFirst
              ? Radius.circular(layout.endListRadius.medium)
              : Radius.circular(layout.innerListRadius.medium),
      bottom:
          isLast
              ? Radius.circular(layout.endListRadius.medium)
              : Radius.circular(layout.innerListRadius.medium),
    );
  }
}

extension GroupedCards on List<Widget> {
  List<Widget> groupedCards({
    double? overrideLastPadding,
    Color? overrideColor,
  }) => [
    for (int i = 0; i < length; i++)
      GroupedCard(
        isFirst: i == 0,
        isLast: i == length - 1,
        overrideLastPadding: overrideLastPadding,
        overrideColor: overrideColor,
        child: this[i],
      ),
  ];
}

extension GroupedCardsGroups on List<List<Widget>> {
  List<Widget> groupedCards({
    double? overrideLastPadding,
    Color? overrideColor,
  }) => [
    for (int i = 0; i < length; i++)
      ...this[i].groupedCards(
        overrideLastPadding: overrideLastPadding,
        overrideColor: overrideColor,
      ),
  ];
}

extension NamedGroupedCardsGroups on Map<String, List<Widget>> {
  List<Widget> groupedCards({
    double? overrideLastPadding,
    Color? overrideColor,
  }) => [
    for (final entry in entries)
      Builder(
        builder: (context) {
          return ListSection(
            title: Text(entry.key),
            children: entry.value.groupedCards(
              overrideLastPadding:
                  overrideLastPadding ?? context.theme.layout.margin.small,
              overrideColor: overrideColor,
            ),
          );
        },
      ),
  ];
}

typedef CardsGroup = ({String title, Widget? leading});

extension NamedLeadingGroupedCardsGroups on Map<CardsGroup, List<Widget>> {
  List<Widget> groupedCards({
    double? overrideLastPadding,
    Color? overrideColor,
    double? topMargin,
  }) => [
    for (final entry in entries)
      Builder(
        builder: (context) {
          return ListSection(
            topMargin: topMargin,
            title: Text(entry.key.title),
            leading: entry.key.leading,
            children: entry.value.groupedCards(
              overrideLastPadding:
                  overrideLastPadding ?? context.theme.layout.margin.small,
              overrideColor: overrideColor,
            ),
          );
        },
      ),
  ];
}

extension NamedGroupedCardsGroupsBuilder<T> on Map<T, List<Widget>> {
  List<Widget> groupedCardsBuilder({
    double? overrideLastPadding = 0,
    Color? overrideColor,
    required Widget Function(T key) titleBuilder,
  }) => [
    for (final entry in entries)
      Builder(
        builder: (context) {
          return ListSection(
            title: titleBuilder(entry.key),
            children: entry.value.groupedCards(
              overrideLastPadding:
                  overrideLastPadding ?? context.theme.layout.margin.small,
              overrideColor: overrideColor,
            ),
          );
        },
      ),
  ];
}
