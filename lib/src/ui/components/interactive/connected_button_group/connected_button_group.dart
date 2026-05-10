import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

part 'button_connection.dart';
part 'connected_button.dart';

class ConnectedButtonGroup<T> extends StatefulWidget {
  const ConnectedButtonGroup({
    super.key,
    required this.connections,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.multiSelectionEnabled = true,
    this.emptySelectionAllowed = true,
    this.overrideUnselectedBackgroundColor,
    this.overrideHorizontalMargin,
    this.expandHorizontally = true,
    this.scrollable = false,
  });

  ConnectedButtonGroup.single({
    super.key,
    required this.connections,
    required T selectedValue,
    required ValueChanged<T> onSelect,
    this.overrideUnselectedBackgroundColor,
    this.overrideHorizontalMargin,
    this.expandHorizontally = true,
    this.scrollable = false,
  }) : selectedValues = {selectedValue},
       multiSelectionEnabled = false,
       emptySelectionAllowed = false,
       onSelectionChanged = ((Set<T> set) {
         onSelect(set.first);
       });

  ConnectedButtonGroup.singleNullable({
    super.key,
    required this.connections,
    required T? selectedValue,
    required ValueChanged<T?> onSelect,
    this.overrideUnselectedBackgroundColor,
    this.overrideHorizontalMargin,
    this.expandHorizontally = true,
    this.scrollable = false,
    // ignore: use_null_aware_elements
  }) : selectedValues = {if (selectedValue != null) selectedValue},
       multiSelectionEnabled = false,
       emptySelectionAllowed = true,
       onSelectionChanged = ((Set<T> set) {
         onSelect(set.isEmpty ? null : set.first);
       });

  final List<ButtonConnection<T>> connections;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>> onSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final Color? overrideUnselectedBackgroundColor;
  final double? overrideHorizontalMargin;
  final bool expandHorizontally;
  final bool scrollable;

  @override
  State<ConnectedButtonGroup<T>> createState() =>
      _ConnectedButtonGroupState<T>();
}

class _ConnectedButtonGroupState<T> extends State<ConnectedButtonGroup<T>> {
  int? pressedDownIndex;

  void onTapDown(int index) {
    ++_id;
    _lastTapDown = DateTime.now();
    setState(() {
      pressedDownIndex = index;
    });
  }

  DateTime? _lastTapDown;
  int _id = 0;
  void onTapUp() async {
    _id++;
    int id = _id;
    if ((_lastTapDown?.difference(DateTime.now()).inMilliseconds ?? 0) <
        Durations.long1.inMilliseconds) {
      await Future.delayed(Durations.short3);
    }
    if (!mounted) return;
    if (id != _id) return;
    setState(() {
      pressedDownIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final children = <Widget>[
      for (int i = 0; i < widget.connections.length; i++)
        if (widget.connections[i] case ButtonConnection<T> connection)
          if (i < widget.connections.length - 1 &&
                  widget.selectedValues.contains(
                    widget.connections[i + 1].value,
                  )
              case bool isRightSelected)
            if (widget.selectedValues.contains(connection.value)
                case bool isSelected) ...[
              GenericAnimatedBuilder(
                curve: Easings.emphasized,
                duration: Durations.medium4,
                value: pressedDownIndex == i ? 1.0 : 0.0,
                child: _ConnectedButton<T>(
                  unselectedBackgroundColor:
                      widget.overrideUnselectedBackgroundColor ??
                      theme.colorScheme.surfaceContainerHigh,
                  connection: connection,
                  isSelected: isSelected,
                  onPressed: () => onTap(connection),
                  onTapDown: () => onTapDown(i),
                  onTapUp: onTapUp,
                  isFirst: i == 0,
                  isLast: i == widget.connections.length - 1,
                  isLeftSelected:
                      i > 0 &&
                      widget.selectedValues.contains(
                        widget.connections[i - 1].value,
                      ),
                  isRightSelected: isRightSelected,
                ),
                builder: (context, value, child) {
                  if (widget.expandHorizontally && !widget.scrollable) {
                    return Expanded(
                      flex: (value.rangeMap(to: (1, 1.15)) * 10000).round(),
                      child: child!,
                    );
                  }
                  return child!;
                },
              ),
              if (i < widget.connections.length - 1)
                AnimatedContainer(
                  duration: Durations.medium3,
                  curve: Easings.standard,
                  width: isRightSelected || isSelected
                      ? layout.spacing.smaller
                      : layout.spacing.tiny,
                ),
            ],
    ];

    if (children.isEmpty) return const SizedBox();

    return widget.scrollable
        ? Stack(
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: 0,
                    child: IgnorePointer(ignoring: true, child: children.first),
                  ),
                  Spacer(),
                ],
              ),
              Positioned.fill(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        widget.overrideHorizontalMargin ?? layout.margin.medium,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: children.length,
                  itemBuilder: (context, index) => children[index],
                ),
              ),
            ],
          )
        : Pad(
            horizontal: widget.overrideHorizontalMargin ?? layout.margin.medium,
            child: Row(
              mainAxisSize: widget.expandHorizontally
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: children,
            ),
          );
  }

  void onTap(ButtonConnection<T> connection) {
    final bool isSelected = widget.selectedValues.contains(connection.value);
    if (widget.multiSelectionEnabled) {
      final newSelection = Set<T>.from(widget.selectedValues);
      if (isSelected) {
        if (widget.emptySelectionAllowed || newSelection.length > 1) {
          newSelection.remove(connection.value);
        }
      } else {
        newSelection.add(connection.value);
      }
      widget.onSelectionChanged(newSelection);
    } else {
      if (!isSelected) {
        widget.onSelectionChanged({connection.value});
      } else if (widget.emptySelectionAllowed) {
        widget.onSelectionChanged({});
      }
    }
  }
}
