import 'package:currency_formatter/currency_formatter.dart';
import 'package:decimal/decimal.dart';

String formatCurrency(String amount) {
  try {
    CurrencyFormatter cf = CurrencyFormatter();

    CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
      symbol: '',
      symbolSide: SymbolSide.right,
      thousandSeparator: ',',
      decimalSeparator: '.',
    );

    final formatted = cf.format(amount, euroSettings);

    return formatted;
  } catch (e) {
    return "..";
  }
}


class TotalPriceArgs {
  final String price;
  final int quantity;

  const TotalPriceArgs({
    required this.price,
    required this.quantity,
  });
}

String calculateTotal(Iterable<TotalPriceArgs> list) {
  final arr = list.map((e) {
    final subTotal = Decimal.parse(e.price) * Decimal.fromInt(e.quantity);
    return subTotal;
  }).toList();

  var sum = Decimal.parse("0.00");

  for (var i = 0; i < arr.length; i++) {
    sum += arr[i];
  }

  return formatCurrency(sum.toString());
}
