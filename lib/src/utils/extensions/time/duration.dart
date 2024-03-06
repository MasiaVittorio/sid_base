import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';

extension DurationFormat on Duration {
  String formattedString(
    BuildContext context, {
    DurationTersity tersity = DurationTersity.second,
    DurationTersity upperTersity = DurationTersity.week,
    String? spacer,
    String? delimiter,
    String? conjunction,
    bool abbreviated = false,
    bool first = true,
  }) =>
      prettyDuration(
        this,
        abbreviated: abbreviated,
        conjunction: conjunction,
        delimiter: delimiter,
        first: first,
        locale: DurationLocale.fromLanguageCode(Localizations.localeOf(context).languageCode) ??
            const EnglishDurationLocale(),
        spacer: spacer,
        tersity: tersity,
        upperTersity: upperTersity,
      );
}
