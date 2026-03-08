import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class GroupedCard extends StatelessWidget {
  const GroupedCard({
    super.key,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    this.horizontalMargin,
    this.lastPadding,
    this.backgroundColor,
  });

  final bool isFirst;
  final bool isLast;
  final Widget child;
  final double? horizontalMargin;
  final double? lastPadding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final layout = context.theme.layout;
    final groupedTheme = GroupedCardTheme.of(context);

    return Pad(
      horizontal:
          horizontalMargin ??
          groupedTheme.horizontalMargin ??
          layout.margin.medium,
      bottom: bottomMargin(
        context: context,
        isLast: isLast,
        lastPaddingOverride: lastPadding,
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius(layout, isFirst: isFirst, isLast: isLast),
        color:
            backgroundColor ??
            groupedTheme.backgroundColor ??
            context.theme.colorScheme.surfaceContainerHigh,
        child: child,
      ),
    );
  }

  static double bottomMargin({
    required BuildContext context,
    required bool isLast,
    double? lastPaddingOverride,
  }) {
    final layout = context.theme.layout;
    final groupedTheme = GroupedCardTheme.of(context);
    return isLast
        ? (lastPaddingOverride ??
            groupedTheme.lastPadding ??
            layout.margin.medium)
        : layout.spacing.tiny;
  }

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
  List<Widget> groupedCards({double? lastPadding, Color? backgroundColor}) => [
    for (int i = 0; i < length; i++)
      GroupedCard(
        isFirst: i == 0,
        isLast: i == length - 1,
        lastPadding: lastPadding,
        backgroundColor: backgroundColor,
        child: this[i],
      ),
  ];
}

extension GroupedCardsGroups on List<List<Widget>> {
  List<Widget> groupedCards({double? lastPadding, Color? backgroundColor}) => [
    for (int i = 0; i < length; i++)
      ...this[i].groupedCards(
        lastPadding: lastPadding,
        backgroundColor: backgroundColor,
      ),
  ];
}

extension NamedGroupedCardsGroups on Map<String, List<Widget>> {
  List<Widget> groupedCards({double? lastPadding, Color? backgroundColor}) => [
    for (final entry in entries)
      Builder(
        builder: (context) {
          return ListSection(
            title: Text(entry.key),
            children: entry.value.groupedCards(
              lastPadding: lastPadding ?? context.theme.layout.margin.small,
              backgroundColor: backgroundColor,
            ),
          );
        },
      ),
  ];
}

typedef CardsGroup = ({String title, Widget? leading});

extension NamedLeadingGroupedCardsGroups on Map<CardsGroup, List<Widget>> {
  List<Widget> groupedCards({
    double? lastPadding,
    Color? backgroundColor,
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
              lastPadding: lastPadding ?? context.theme.layout.margin.small,
              backgroundColor: backgroundColor,
            ),
          );
        },
      ),
  ];
}

extension NamedGroupedCardsGroupsBuilder<T> on Map<T, List<Widget>> {
  List<Widget> groupedCardsBuilder({
    double? lastPadding = 0,
    Color? backgroundColor,
    required Widget Function(T key) titleBuilder,
  }) => [
    for (final entry in entries)
      Builder(
        builder: (context) {
          return ListSection(
            title: titleBuilder(entry.key),
            children: entry.value.groupedCards(
              lastPadding: lastPadding ?? context.theme.layout.margin.small,
              backgroundColor: backgroundColor,
            ),
          );
        },
      ),
  ];
}

class GroupedCardThemeData {
  final double? horizontalMargin;
  final double? lastPadding;
  final Color? backgroundColor;

  const GroupedCardThemeData({
    this.horizontalMargin,
    this.lastPadding,
    this.backgroundColor,
  });

  static const empty = GroupedCardThemeData();

  @override
  bool operator ==(covariant GroupedCardThemeData other) {
    if (identical(this, other)) return true;

    return other.horizontalMargin == horizontalMargin &&
        other.lastPadding == lastPadding &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode =>
      horizontalMargin.hashCode ^
      lastPadding.hashCode ^
      backgroundColor.hashCode;
}

class GroupedCardTheme extends InheritedWidget {
  const GroupedCardTheme({super.key, required this.data, required super.child});

  final GroupedCardThemeData data;

  static GroupedCardThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<GroupedCardTheme>();
    return theme?.data ?? GroupedCardThemeData.empty;
  }

  @override
  bool updateShouldNotify(GroupedCardTheme oldWidget) => data != oldWidget.data;
}
