part of 'connected_button_group.dart';

class ButtonConnection<T> {
  final T value;
  final Widget? label;
  final Widget? unselectedIcon;
  final Widget? selectedIcon;

  const ButtonConnection.withLabel({
    required this.value,
    required Widget this.label,
    this.unselectedIcon,
    this.selectedIcon,
  });

  const ButtonConnection.withIcon({
    required this.value,
    required Widget this.selectedIcon,
    this.label,
    this.unselectedIcon,
  });

  const ButtonConnection({
    required this.value,
    this.selectedIcon,
    this.label,
    this.unselectedIcon,
  }) : assert(
         label != null || selectedIcon != null || unselectedIcon != null,
         "Either label or an icon must be provided",
       );
}
