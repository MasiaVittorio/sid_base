import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sid_base/src/ui/components/interactive/color_picker/components/animated_clipper.dart';

const double _kBottomMargin = 8.0;

const Duration _myDuration = Duration(milliseconds: 200);
const double _tileSize = 48.0;

class SimpleNavBar extends StatelessWidget {
  SimpleNavBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.iconSize = 24.0,
    this.duration = _myDuration,
    this.titleStyle,
    this.iconColor,
    this.inactiveIconColor,
    this.height = kBottomNavigationBarHeight,
  })  : assert(items.length >= 2),
        assert(
          items.every((SimpleItem item) => item.title != null),
          'Every item must have a non-null title',
        ),
        assert(0 <= currentIndex && currentIndex < items.length);

  final List<SimpleItem> items;
  final ValueChanged<int>? onTap; //stream ? or listener ? callbacks dude
  final int currentIndex;
  final double iconSize;
  final Duration duration;

  final TextStyle? titleStyle;
  final Color? iconColor;
  final Color? inactiveIconColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = math.max(
      MediaQuery.of(context).padding.bottom - _kBottomMargin,
      0.0,
    );

    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height + additionalBottomPadding),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: additionalBottomPadding,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: _createContainer(_createTiles()),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createTiles() {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < items.length; i += 1) {
      bool selI = i == currentIndex;

      onTapI() {
        if (onTap != null) onTap!(i);
      }

      onTapPrev() {
        if (onTap != null) {
          if (selI) {
            onTap!(i == 0 ? i : i - 1);
          } else {
            onTap!(i);
          }
        }
      }

      onTapNext() {
        if (onTap != null) {
          if (selI) {
            onTap!(i == items.length - 1 ? i : i + 1);
          } else {
            onTap!(i);
          }
        }
      }

      children.add(Expanded(
          child: InkResponse(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTapPrev,
      )));
      children.add(
        _SimpleTile(
          items[i],
          iconSize,
          titleStyle: titleStyle,
          duration: duration,
          onTap: onTapI,
          iconColor: iconColor,
          selected: selI,
          inactiveIconColor: inactiveIconColor,
          height: height,
        ),
      );
      children.add(Expanded(
          child: InkResponse(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTapNext,
      )));
    }
    return children;
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Container(
        constraints: BoxConstraints(maxHeight: height),
        child: Row(
          children: tiles,
        ),
      ),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  const _SimpleTile(
    this.item,
    this.iconSize, {
    this.onTap,
    this.selected = false,
    // ignore: unused_element
    this.indexLabel,
    this.titleStyle,
    required this.duration,
    required this.height,
    required this.iconColor,
    required this.inactiveIconColor,
  });

  final double height;
  final TextStyle? titleStyle;
  final Duration duration;
  final SimpleItem item;
  final double iconSize;
  final VoidCallback? onTap;
  final bool selected;
  final String? indexLabel;
  final Color? iconColor;
  final Color? inactiveIconColor;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(
      item.title!,
      style: titleStyle?.copyWith(color: item.color),
    );

    return Semantics(
      container: true,
      header: true,
      selected: selected,
      child: InkResponse(
        // splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        containedInkWell: false,
        onTap: onTap,
        child: Container(
          height: height,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _TileIcon(
                duration: duration,
                iconSize: iconSize,
                selected: selected,
                iconColor: iconColor,
                inactiveIconColor: inactiveIconColor,
                item: item,
              ),
              AnimatedClipper(
                alsoFade: true,
                childAlignment: Alignment.centerLeft,
                clip: !selected,
                axis: Axis.horizontal,
                axisAlignment: -1.0,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    required this.iconSize,
    required this.selected,
    required this.item,
    required this.duration,
    required this.iconColor,
    required this.inactiveIconColor,
  });

  final Duration duration;
  final double iconSize;
  final bool selected;
  final SimpleItem item;
  final Color? iconColor;
  final Color? inactiveIconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _tileSize,
      width: _tileSize,
      child: Center(
        child: IconTheme(
          data: IconThemeData(
            size: iconSize,
          ),
          child: AnimatedCrossFade(
              firstChild: Icon(item.activeIcon, color: item.color),
              secondChild: Icon(item.icon, color: inactiveIconColor),
              crossFadeState: selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: duration),
        ),
      ),
    );
  }
}

class SimpleItem {
  const SimpleItem({
    required this.icon,
    this.title,
    IconData? activeIcon,
    required this.color,
  }) : activeIcon = activeIcon ?? icon;

  final IconData icon;
  final IconData activeIcon;
  final String? title;
  final Color color;
}
