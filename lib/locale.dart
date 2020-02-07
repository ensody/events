import 'package:intl/intl.dart';

// TODO: Setup some real i18n logic if we have time...

String formatDate(DateTime dateTime) {
  return DateFormat.yMd().add_Hm().format(dateTime);
}

// TODO: Get rid of nullability
String formatDateRange(DateTime start, DateTime end) {
  String result;
  if (start != null) {
    result = '${formatDate(start)}';
    if (end != null) {
      result += ' - ${formatDate(end)}';
    }
  }
  return result;
}
