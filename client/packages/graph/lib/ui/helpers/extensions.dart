extension StringParsing on String {
  String cleanSpaces() {
    return replaceAll(RegExp(r"\s+"), " ");
  }
}

