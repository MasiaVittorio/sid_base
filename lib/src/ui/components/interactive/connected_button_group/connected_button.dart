// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'connected_button_group.dart';

class _ConnectedButton<T> extends StatelessWidget {
  const _ConnectedButton({
    super.key,
    required this.connection,
    required this.isSelected,
    required this.onPressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.isFirst,
    required this.isLast,
    required this.isLeftSelected,
    required this.isRightSelected,
    required this.unselectedBackgroundColor,
  });

  final ButtonConnection<T> connection;
  final bool isSelected;
  final VoidCallback onPressed;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final bool isFirst;
  final bool isLast;

  final bool isLeftSelected;
  final bool isRightSelected;
  final Color unselectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    double sideRadius(bool isSideSelected, bool isEnd) {
      return switch ((isSelected, isSideSelected, isEnd)) {
        (false, _, true) => layout.radius.smaller,
        (true, _, true) => layout.radius.huge,
        (false, false, false) => layout.radius.tiny,
        (false, true, false) => layout.radius.smaller,
        (true, _, false) => layout.radius.huge,
      };
    }

    final Color foregroundColor = switch (isSelected) {
      true => theme.colorScheme.onPrimaryContainer,
      false => theme.colorScheme.onSurface,
    };

    final Widget? icon = isSelected
        ? connection.selectedIcon ?? connection.unselectedIcon
        : connection.unselectedIcon ?? connection.selectedIcon;

    return AnimatedContainer(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(sideRadius(isLeftSelected, isFirst)),
          right: Radius.circular(sideRadius(isRightSelected, isLast)),
        ),
        color: switch (isSelected) {
          true => theme.colorScheme.primaryContainer,
          false => unselectedBackgroundColor,
        },
      ),
      curve: Easings.emphasized,
      duration: Durations.long1,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          onTapDown: (_) => onTapDown(),
          onTapUp: (_) => onTapUp(),
          onTapCancel: onTapUp,
          child: Pad(
            horizontal: layout.padding.small,
            vertical: layout.padding.medium,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon case Widget icon)
                    IconTheme(
                      data: IconTheme.of(
                        context,
                      ).copyWith(color: foregroundColor, size: 22),
                      child: icon,
                    ),
                  if (connection.label case Widget label)
                    DefaultTextStyle(
                      style: DefaultTextStyle.of(context).style.merge(
                        theme.textTheme.labelMedium!.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                      child: label,
                    ),
                ].separateWith(Space.horizontal(layout.spacing.smaller)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
