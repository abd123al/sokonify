/// https://github.com/comigor/artemis/blob/master/example/graphbrainz/lib/coercers.dart
DateTime fromGraphQLTimeToDartDateTime(String date) {
  return DateTime.parse(date).toLocal();
}

/// https://github.com/comigor/artemis/issues/293#issuecomment-818216604
String fromDartDateTimeToGraphQLTime(DateTime date) {
  return date.toLocal().toString();
}
