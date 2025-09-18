import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.thickness = 1,
    this.cross = 0,
    this.main = 0,
    this.start = 0,
    this.end = 0,
    this.before = 0,
    this.after = 0,
    this.all = 0,
    this.color,
    this.axis = Axis.horizontal,
    this.rounded = false,
    this.length,
  });
  const CustomDivider.vertical({
    super.key,
    this.thickness = 1,
    this.cross = 0,
    this.main = 0,
    this.start = 0,
    this.end = 0,
    this.before = 0,
    this.after = 0,
    this.all = 0,
    this.color,
    this.rounded = false,
    this.length,
  }) : axis = Axis.vertical;
  const CustomDivider.horizontal({
    super.key,
    this.thickness = 1,
    this.cross = 0,
    this.main = 0,
    this.start = 0,
    this.end = 0,
    this.before = 0,
    this.after = 0,
    this.all = 0,
    this.color,
    this.rounded = false,
    this.length,
  }) : axis = Axis.horizontal;

  final double cross;
  final double main;
  final double start;
  final double end;
  final double before;
  final double after;
  final double all;
  final Color? color;
  final double thickness;
  final Axis axis;
  final bool rounded;
  final double? length;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            rounded ? BorderRadius.circular(thickness) : BorderRadius.zero,
        color: color ?? context.theme.dividerTheme.color,
      ),
      margin: switch (axis) {
        Axis.horizontal => EdgeInsets.fromLTRB(
          start + cross + all,
          before + main + all,
          end + cross + all,
          after + main + all,
        ),
        Axis.vertical => EdgeInsets.fromLTRB(
          before + main + all,
          start + cross + all,
          after + main + all,
          end + cross + all,
        ),
      },
      width: switch (axis) {
        Axis.horizontal => length ?? double.infinity,
        Axis.vertical => thickness,
      },
      height: switch (axis) {
        Axis.horizontal => thickness,
        Axis.vertical => length ?? double.infinity,
      },
    );
  }
}
