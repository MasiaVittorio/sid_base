import 'package:intl/intl.dart' show DateFormat;

extension FormatDateTime on DateTime {
  String format(String f) => DateFormat(f).format(this);
}

