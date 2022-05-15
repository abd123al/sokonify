import 'package:intl/intl.dart';

/// https://github.com/comigor/artemis/blob/master/example/graphbrainz/lib/coercers.dart
DateTime fromGraphQLTimeToDartDateTime(String date) {
  try {
    return DateTime.parse(date);
  } catch (_) {
    /// This is because sometimes faker js returns invalid dates
    return DateTime.now();
  }
}

String fromDartDateTimeToGraphQLTime(DateTime date) {
  final dateFormatter = DateFormat('dd-MM-yyyy');

  try {
    final f = dateFormatter.format(date);
    //print("dateFormatter: $f");
    return f;
  } catch (_) {
    return '';
  }
}
