import '../ui/helpers/currency_formatter.dart';

/// https://github.com/comigor/artemis/blob/master/example/graphbrainz/lib/coercers.dart
DateTime fromGraphQLTimeToDartDateTime(String date) {
  return DateTime.parse(date).toLocal();
}

/// https://github.com/comigor/artemis/issues/293#issuecomment-818216604
String fromDartDateTimeToGraphQLTime(DateTime date) {
  return formatToGoTime(date);
}

DateTime? fromGraphQLTimeNullableToDartDateTimeNullable(String? date) {
  if (date != null) {
    return DateTime.parse(date).toLocal();
  }
  return null;
}

String? fromDartDateTimeNullableToGraphQLTimeNullable(DateTime? date) {
  if (date != null) {
    return formatToGoTime(date);
  }
  return null;
}
