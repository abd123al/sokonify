extension StringParsing on String {
  String cleanSpaces() {
    return replaceAll(RegExp(r"\s+"), " ");
  }

  int toInt() {
    return int.parse(this);
  }
}
