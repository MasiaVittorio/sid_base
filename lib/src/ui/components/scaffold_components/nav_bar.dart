// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sid_base/sid_base.dart';

class NavBarItem {
  final String label;
  final IconData icon;
  final IconData iconActive;

  const NavBarItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : iconActive = activeIcon ?? icon;

  @override
  String toString() =>
      'NavBarItem(label: $label, icon: $icon, iconActive: $iconActive)';

  @override
  bool operator ==(covariant NavBarItem other) {
    if (identical(this, other)) return true;

    return other.label == label &&
        other.icon == icon &&
        other.iconActive == iconActive;
  }

  @override
  int get hashCode => label.hashCode ^ icon.hashCode ^ iconActive.hashCode;
}

class MD3NavBar extends StatelessWidget {
  const MD3NavBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.overrideBackgroundColor,
    this.elevation = 2,
  }) : super(key: key);

  final List<NavBarItem> items;
  final int currentIndex;
  final void Function(int) onTap;
  final double elevation;
  final Color? overrideBackgroundColor;

  static const double height = 76;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: overrideBackgroundColor ?? theme.elevatedSurface(elevation),
      child: SafeArea(
        bottom: true,
        top: false,
        right: false,
        left: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: _Tab(
                    icon: items[i].icon,
                    activeIcon: items[i].iconActive,
                    active: i == currentIndex,
                    label: items[i].label,
                    onTap: () => onTap(i),
                    chipRestElevation: elevation,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.active,
    required this.label,
    required this.onTap,
    required this.chipRestElevation,
  }) : super(key: key);

  final IconData icon;
  final IconData? activeIcon;
  final bool active;
  final String label;
  final VoidCallback onTap;
  final double chipRestElevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final Color labelColor =
        active ? colorScheme.onSurface : colorScheme.onSurfaceVariant;
    final labelStyle = textTheme.labelLarge!.copyWith(
      fontWeight: active
          ? textTheme.labelLarge!.fontWeight
          : textTheme.labelMedium!.fontWeight,
      color: labelColor,
    );
    return InkResponse(
      containedInkWell: false,
      onTap: onTap,
      child: Column(
        children: [
          const Spacer(flex: 10),
          _NavChip(
            icon: icon,
            expanded: active,
            activeIcon: activeIcon,
            elevation: chipRestElevation,
          ),
          const Spacer(flex: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: labelStyle,
          ),
          const Spacer(flex: 10),
        ],
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.expanded,
    required this.elevation,
  }) : super(key: key);

  final IconData icon;
  final IconData? activeIcon;
  final bool expanded;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      height: 32,
      width: expanded ? 64 : 32,
      decoration: BoxDecoration(
        color: expanded
            ? theme.colorScheme.secondaryContainer
            : theme.elevatedSurface(elevation),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          expanded ? (activeIcon ?? icon) : icon,
          size: 24,
          color: expanded
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
