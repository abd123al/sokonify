import 'package:intl/intl.dart';

extension StringParsing on String {
  String cleanSpaces() {
    return replaceAll(RegExp(r"\s+"), " ");
  }

  int toInt() {
    return int.parse(this);
  }
}

extension DateParsing on DateTime? {
  String? toTime() {
    if (this != null) {
      var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
      var outputDate = outputFormat.format(this!);
      return outputDate;
    }

    return null;
  }
}
