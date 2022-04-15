import 'package:intl/intl.dart';

/// https://github.com/comigor/artemis/blob/master/example/graphbrainz/lib/coercers.dart
DateTime fromGraphQLDateTimeToDartDateTime(String date) {
  try {
    return DateTime.parse(date);
  } catch (_) {
    /// This is because sometimes faker js returns invalid dates
    return DateTime.now();
  }
}

String fromDartDateTimeToGraphQLDateTime(DateTime date) {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  try {
    return dateFormatter.format(date);
  } catch (_) {
    return dateFormatter.format(DateTime.now());
  }
}
