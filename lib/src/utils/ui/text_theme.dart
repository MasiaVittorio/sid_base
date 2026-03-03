import 'package:flutter/material.dart';

extension TextThemeFamilyChanger on TextTheme {

  TextTheme withFamilies({
    String? display,
    String? headline,
    String? title,
    String? body,
    String? label,
  }) => copyWith(
    displayLarge: displayLarge!.copyWith(fontFamily: display),
    displayMedium: displayMedium!.copyWith(fontFamily: display),
    displaySmall: displaySmall!.copyWith(fontFamily: display),
    headlineLarge: headlineLarge!.copyWith(fontFamily: headline),
    headlineMedium: headlineMedium!.copyWith(fontFamily: headline),
    headlineSmall: headlineSmall!.copyWith(fontFamily: headline),
    titleLarge: titleLarge!.copyWith(fontFamily: title),
    titleMedium: titleMedium!.copyWith(fontFamily: title),
    titleSmall: titleSmall!.copyWith(fontFamily: title),
    bodyLarge: bodyLarge!.copyWith(fontFamily: body),
    bodyMedium: bodyMedium!.copyWith(fontFamily: body),
    bodySmall: bodySmall!.copyWith(fontFamily: body),
    labelLarge: labelLarge!.copyWith(fontFamily: label),
    labelMedium: labelMedium!.copyWith(fontFamily: label),
    labelSmall: labelSmall!.copyWith(fontFamily: label),
  );

}
