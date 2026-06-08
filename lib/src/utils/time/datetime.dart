import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:timeago/timeago.dart' as timeago;

export 'package:intl/intl.dart' show DateFormat;

class TimeAgo {
  static void addItalianMessages() =>
      timeago.setLocaleMessages('it', timeago.ItMessages());
}

extension FormatDateTime on DateTime {
  String format(String f) => DateFormat(f).format(this);

  String timeAgo(BuildContext context) => timeago.format(
    this,
    locale: Localizations.localeOf(context).languageCode,
  );
}
