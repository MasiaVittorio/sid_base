import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExpandableAppBarList extends StatelessWidget {
  const ExpandableAppBarList({
    super.key,
    required this.title,
    required this.children,
    this.userDirectionOverlay,
    this.forceExpandAppBar,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.threshold = 12,
    this.actions = const [],
  });

  final Widget Function(
    BuildContext _,
    ScrollDirection? userDirection,
  )? userDirectionOverlay;

  final String title;
  final List<Widget> children;
  final bool? forceExpandAppBar;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final double threshold;
  final List<Widget> actions;

  bool get _verbose => false;

  @override
  Widget build(BuildContext context) {
    final safe = context.safe;
    final topSafe = safe.top;

    final topCollapsed = ExpandableAppBar.collapsedHeight + topSafe;
    final topExpanded = ExpandableAppBar.expandedHeightLarge + topSafe;

    final topDelta = topExpanded - topCollapsed;
    assert(topDelta > 0);

    double topPadding(bool overThreshold, bool? atEnd, _, __) {
      if (atEnd == null) {
        if (_verbose) {
          debugPrint(
              "top 1.1: at end null (equal to not scrollable): topExpanded");
        }
        return topExpanded;
      }
      if (atEnd) {
        if (overThreshold) {
          if (_verbose) {
            debugPrint("top 2.1: at end over threshold: topCollapsed easy");
          }
          return topCollapsed;
        } else {
          if (_verbose) {
            debugPrint("top 3: at end before threshold: topExpanded");
          }
          return topExpanded;
        }
      }
      if (overThreshold) {
        if (_verbose) {
          debugPrint("top 4: before end over threshold: topCollapsed");
        }
        return topCollapsed;
      } else {
        if (_verbose) {
          debugPrint("top 5: before end before threshold: topExpanded");
        }
        return topExpanded;
      }
    }

    double bottomPadding(
        bool overThreshold, bool? atEnd, _, double? initialMaxScrollExtent) {
      if (atEnd == null) {
        if (_verbose) {
          debugPrint("bottom 2: at end null (not scrollable): bottomExpanded");
        }
        return 0;
      }
      double upBy = switch (overThreshold) {
        true => threshold + topDelta,
        false => 0,
      };
      if (_verbose) {
        debugPrint("bottom 3: up by $upBy");
      }
      if (initialMaxScrollExtent == null) {
        if (_verbose) {
          debugPrint("bottom 4: initial max scroll extent null");
        }
        return 0;
      }
      if (_verbose) {
        debugPrint(
            "bottom 5: initial max scroll extent $initialMaxScrollExtent");
      }
      if (upBy > initialMaxScrollExtent) {
        if (_verbose) {
          debugPrint("bottom 6: upBy > max, returning difference + 5");
        }
        return upBy - initialMaxScrollExtent + 5;
      }
      if (_verbose) {
        debugPrint("bottom 7: upBy < max returning zero");
      }
      return 0;
    }

    return ResponsiveScrollStack(
      threshold: threshold,
      bubbleUpNotifications: false,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      userDirectionOverlay: userDirectionOverlay,
      thresholdOverlay: (_, overThreshold) => Align(
        alignment: Alignment.topCenter,
        child: ExpandableAppBar(
          expandedHeight: ExpandableAppBar.expandedHeightLarge,
          expanded: forceExpandAppBar ?? !overThreshold,
          title: title,
          automaticallyImplyLeading: automaticallyImplyLeading,
          leading: leading,
          centered: true,
          actions: actions,
          expandedColor: context.theme.scaffoldBackgroundColor,
        ),
      ),
      children: children,
    );
  }
}
