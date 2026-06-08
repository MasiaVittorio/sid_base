import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/material.dart';

extension LayoutFromTheme on ThemeData {
  Layout get layout => extension<Layout>() ?? Layout.defaultLayout;
}

class Layout extends ThemeExtension<Layout> {
  final LayoutSize spacing;
  final LayoutSize margin;
  final LayoutSize padding;
  final LayoutSize radius;
  final LayoutSize endListRadius;
  final LayoutSize innerListRadius;
  final LayoutThickness borderThickness;
  final LayoutSize buttonSize;

  const Layout({
    required this.spacing,
    required this.margin,
    required this.padding,
    required this.radius,
    required this.endListRadius,
    required this.innerListRadius,
    required this.borderThickness,
    required this.buttonSize,
  });

  static const defaultLayout = Layout(
    spacing: LayoutSize(
      tiny: 3,
      smaller: 6,
      small: 8,
      medium: 10,
      large: 12,
      larger: 16,
      huge: 24,
    ),
    margin: LayoutSize(
      tiny: 8,
      smaller: 10,
      small: 12,
      medium: 16,
      large: 20,
      larger: 24,
      huge: 32,
    ),
    padding: LayoutSize(
      tiny: 4,
      smaller: 6,
      small: 8,
      medium: 10,
      large: 12,
      larger: 16,
      huge: 24,
    ),
    radius: LayoutSize(
      tiny: 4,
      smaller: 8,
      small: 12,
      medium: 16,
      large: 20,
      larger: 24,
      huge: 32,
    ),
    endListRadius: LayoutSize(
      tiny: 6,
      smaller: 10,
      small: 12,
      medium: 16,
      large: 20,
      larger: 24,
      huge: 32,
    ),
    innerListRadius: LayoutSize(
      tiny: 2,
      smaller: 3,
      small: 4,
      medium: 6,
      large: 8,
      larger: 10,
      huge: 12,
    ),
    borderThickness: LayoutThickness(
      thinnest: 0.5,
      thin: 0.5,
      medium: 1,
      thick: 2,
      thickest: 3,
    ),
    buttonSize: LayoutSize(
      tiny: 24,
      smaller: 28,
      small: 32,
      medium: 36,
      large: 40,
      larger: 48,
      huge: 56,
    ),
  );

  @override
  ThemeExtension<Layout> lerp(
    covariant ThemeExtension<Layout>? other,
    double t,
  ) {
    if (other is! Layout) {
      return t > 0.5 ? (other ?? this) : this;
    }
    return Layout(
      spacing: spacing.lerp(other.spacing, t),
      margin: margin.lerp(other.margin, t),
      padding: padding.lerp(other.padding, t),
      radius: radius.lerp(other.radius, t),
      endListRadius: endListRadius.lerp(other.endListRadius, t),
      innerListRadius: innerListRadius.lerp(other.innerListRadius, t),
      borderThickness: borderThickness.lerp(other.borderThickness, t),
      buttonSize: buttonSize.lerp(other.buttonSize, t),
    );
  }

  @override
  ThemeExtension<Layout> copyWith({
    LayoutSize? spacing,
    LayoutSize? margin,
    LayoutSize? padding,
    LayoutSize? radius,
    LayoutSize? endListRadius,
    LayoutSize? innerListRadius,
    LayoutThickness? borderThickness,
    LayoutSize? buttonSize,
  }) {
    return Layout(
      spacing: spacing ?? this.spacing,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      radius: radius ?? this.radius,
      endListRadius: endListRadius ?? this.endListRadius,
      innerListRadius: innerListRadius ?? this.innerListRadius,
      borderThickness: borderThickness ?? this.borderThickness,
      buttonSize: buttonSize ?? this.buttonSize,
    );
  }
}

class LayoutSize extends ThemeExtension<LayoutSize> {
  final double tiny;
  final double smaller;
  final double small;
  final double medium;
  final double large;
  final double larger;
  final double huge;

  const LayoutSize({
    required this.tiny,
    required this.smaller,
    required this.small,
    required this.medium,
    required this.large,
    required this.larger,
    required this.huge,
  });

  @override
  ThemeExtension<LayoutSize> copyWith({
    double? tiny,
    double? smaller,
    double? small,
    double? medium,
    double? large,
    double? larger,
    double? huge,
  }) {
    return LayoutSize(
      tiny: tiny ?? this.tiny,
      smaller: smaller ?? this.smaller,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      larger: larger ?? this.larger,
      huge: huge ?? this.huge,
    );
  }

  @override
  LayoutSize lerp(covariant ThemeExtension<LayoutSize>? other, double t) {
    if (other is! LayoutSize) {
      return this;
    }
    return LayoutSize(
      tiny: ui.lerpDouble(tiny, other.tiny, t) ?? tiny,
      smaller: ui.lerpDouble(smaller, other.smaller, t) ?? smaller,
      small: ui.lerpDouble(small, other.small, t) ?? small,
      medium: ui.lerpDouble(medium, other.medium, t) ?? medium,
      large: ui.lerpDouble(large, other.large, t) ?? large,
      larger: ui.lerpDouble(larger, other.larger, t) ?? larger,
      huge: ui.lerpDouble(huge, other.huge, t) ?? huge,
    );
  }
}

class LayoutThickness extends ThemeExtension<LayoutThickness> {
  final double thinnest;
  final double thin;
  final double medium;
  final double thick;
  final double thickest;

  const LayoutThickness({
    required this.thinnest,
    required this.thin,
    required this.medium,
    required this.thick,
    required this.thickest,
  });

  @override
  ThemeExtension<LayoutThickness> copyWith({
    double? thinnest,
    double? thin,
    double? medium,
    double? thick,
    double? thickest,
  }) {
    return LayoutThickness(
      thinnest: thinnest ?? this.thinnest,
      thin: thin ?? this.thin,
      medium: medium ?? this.medium,
      thick: thick ?? this.thick,
      thickest: thickest ?? this.thickest,
    );
  }

  @override
  LayoutThickness lerp(
    covariant ThemeExtension<LayoutThickness>? other,
    double t,
  ) {
    if (other is! LayoutThickness) {
      return this;
    }
    return LayoutThickness(
      thinnest: ui.lerpDouble(thinnest, other.thinnest, t) ?? thinnest,
      thin: ui.lerpDouble(thin, other.thin, t) ?? thin,
      medium: ui.lerpDouble(medium, other.medium, t) ?? medium,
      thick: ui.lerpDouble(thick, other.thick, t) ?? thick,
      thickest: ui.lerpDouble(thickest, other.thickest, t) ?? thickest,
    );
  }
}
