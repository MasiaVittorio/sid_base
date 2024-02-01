import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/ui/specialty_widgets/expandable_circle_card/external_circle_clipper.dart';

class ExpandableCircleCard extends StatelessWidget {
  static const double _kBorder = 20.0;
  static const double _kTopBorder = 3.0;
  static const double _kContentH = 20.0;
  static const double _kMediumV = 16.0;
  static const double _kSmallH = 12.0;
  const ExpandableCircleCard({
    super.key,
    required this.expanded,
    required this.onExpandedChanged,
    required this.collapsedCircleChild,
    required this.expandedChild,
    required this.expandedCircleChild,
    required this.titleChild,
    this.oppositeColor,
    this.surfaceColor,
    this.borderPadding =
        const EdgeInsets.fromLTRB(_kBorder, _kTopBorder, _kBorder, _kBorder),
    this.overrideCircleBorderWidth,
    this.collapsedCircleRadius = 18,
    this.circleHorizontalPadding = _kSmallH,
    this.dividerWidth = 1,
    this.showDivider = true,
    this.horizontalContentPadding = _kContentH,
    this.topBodyPadding = 6,
    this.bottomBodyPadding = _kContentH * 0.7,
    this.bottomTitlePadding = 8,
    this.topTitlePadding = _kMediumV,
  });

  final Widget collapsedCircleChild;
  final Widget expandedCircleChild;
  final Widget expandedChild;
  final Widget titleChild;

  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;

  final Color? surfaceColor;
  Color _surfaceColor(ThemeData theme) =>
      surfaceColor ?? theme.colorScheme.inverseSurface;
  final Color? oppositeColor;
  Color _oppositeColor(ThemeData theme) =>
      oppositeColor ?? _surfaceColor(theme).contrast;

  final double collapsedCircleRadius;
  double get _collapsedCircleDiameter => collapsedCircleRadius * 2;
  double get _expandedCircleRadius =>
      collapsedCircleRadius + _circleBorderWidth;
  double get _expandedCircleExtraSpaceComparedToTitle =>
      _expandedCircleRadius + (borderPadding.top / 2);
  double get _circleRadius =>
      expanded ? _expandedCircleRadius : collapsedCircleRadius;
  double get _circleDiameter => _circleRadius * 2;

  final EdgeInsets borderPadding;
  final double? overrideCircleBorderWidth;
  double get _circleBorderWidth =>
      overrideCircleBorderWidth ?? borderPadding.top;
  final double circleHorizontalPadding;
  double get circleBoxWidth =>
      _collapsedCircleDiameter +
      (max(circleHorizontalPadding, _circleBorderWidth)) * 2;

  TextStyle _titleStyle(ThemeData theme) => (theme.textTheme.titleMedium ??
          const TextStyle(
              fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w500))
      .copyWith(color: _oppositeColor(theme), height: 1);
  TextStyle _bodyStyle(ThemeData theme) => (theme.textTheme.bodyMedium ??
          const TextStyle(
              fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400))
      .copyWith(color: _oppositeColor(theme));

  final bool showDivider;
  final double dividerWidth;

  final double horizontalContentPadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final double topBodyPadding;
  final double bottomBodyPadding;

  Widget suggestColor({required Color color, required Widget child}) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: color),
        child: IconTheme(
          data: IconTheme.of(context).copyWith(color: color),
          child: child,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      color: _oppositeColor(theme),
      padding: borderPadding,
      child: AnimatedContainer(
        duration: Motion.extraLong4,
        curve: Easings.emphasized,
        decoration: BoxDecoration(
          color: _surfaceColor(theme),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(expanded ? 12 : 8),
            top: Radius.circular(expanded ? 0 : 8),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: _content(context, theme),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () => onExpandedChanged(!expanded),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(context, theme),
          GenericAnimatedBuilder(
            duration: Motion.medium3,
            curve: Easings.emphasized,
            value: expanded ? 1.0 : 0.0,
            builder: (context, value, child) {
              const double f = 0.5;
              final double h =
                  value.mapToRange(0, dividerWidth, fromMin: 0.0, fromMax: f);
              final double wf =
                  value.mapToRange(0.0, 1.0, fromMin: f, fromMax: 1.0);
              return Pad(
                horizontal: horizontalContentPadding,
                child: Al.centerLeft(
                  child: FractionallySizedBox(
                    widthFactor: wf,
                    child: Container(
                      height: h,
                      width: double.infinity,
                      color: _oppositeColor(theme),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedListed(
            overlapSizeAndOpacity: 1,
            listed: expanded,
            duration: Motion.long4,
            curve: Easings.emphasizedDecelerate,
            child: _body(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, ThemeData theme) {
    return DefaultTextStyle(
      style: _titleStyle(theme),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(
              right: circleBoxWidth,
              left: horizontalContentPadding,
              top: topTitlePadding,
              bottom: expanded ? bottomTitlePadding : topTitlePadding,
            ),
            duration: Motion.short4,
            curve: Easings.standard,
            child: titleChild,
          ),
          Positioned(
            right: 0,
            width: circleBoxWidth,
            top: -_expandedCircleExtraSpaceComparedToTitle,
            bottom: -_expandedCircleExtraSpaceComparedToTitle,
            child: AnimatedAlign(
              alignment: expanded ? Alignment.topCenter : Alignment.center,
              duration: Motion.long1,
              curve: Easings.emphasized,
              child: _circle(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ThemeData theme) {
    return Pad(
      horizontal: horizontalContentPadding,
      top: topBodyPadding,
      bottom: bottomBodyPadding,
      child: DefaultTextStyle(
        style: _bodyStyle(theme),
        child: expandedChild,
      ),
    );
  }

  Widget _circle(BuildContext context, ThemeData theme) {
    return AnimatedContainer(
      duration: Motion.short3,
      curve: Easings.standard,
      width: _circleDiameter,
      height: _circleDiameter,
      decoration: BoxDecoration(
        color: _oppositeColor(theme),
        borderRadius: BorderRadius.circular(9000),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
                child: suggestColor(
                    color: _surfaceColor(theme), child: collapsedCircleChild)),
          ),
          Center(
            child: GenericAnimatedBuilder(
                duration: expanded ? Motion.short4 : Motion.long3,
                curve: expanded
                    ? Easings.emphasizedDecelerate
                    : Easings.emphasizedDecelerate,
                value: expanded ? 1.0 : 0.0,
                child: _expandedCircle(theme),
                builder: (context, value, child) {
                  return ExternalCircleClipper(
                    fraction: value.mapToRange(1.0, 0.0),
                    mode: ExternalCircleClipperMode.fromSides,
                    child: child!,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _expandedCircle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor(theme),
        borderRadius: BorderRadius.circular(99999),
      ),
      width: _collapsedCircleDiameter,
      height: _collapsedCircleDiameter,
      child: Center(
        child: suggestColor(
          color: _oppositeColor(theme),
          child: expandedCircleChild,
        ),
      ),
    );
  }
}
