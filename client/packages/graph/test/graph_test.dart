import 'package:flutter_test/flutter_test.dart';
import 'package:graph/ui/ui.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUp(() => {initializeDateFormatting('pt_BR', null)});

  test('formatToGoTime', () async {
    final formatted = formatToGoTime(DateTime.now());
    final extracted = extractGoTime(formatted);

    print("formatted: $formatted");
    print("extracted: $extracted");
    expect(formatted, isNotEmpty);
    expect(extracted.toString(), isNotEmpty);
    expect(formatted.length, "2022-06-30T14:13:37.56575+03:00".length);
  });

  test('extractGoTime', () async {
    final extracted = extractGoTime("2022-06-30T14:13:37.56575+03:00");

    print("extracted: $extracted");
    expect(extracted.toString(), isNotEmpty);
  });

  test('play', () async {
    final parsed = DateTime.parse("2022-06-30T14:13:37.56575");
    print(parsed);
    expect(parsed.toString(), isNotEmpty);
  });
}
