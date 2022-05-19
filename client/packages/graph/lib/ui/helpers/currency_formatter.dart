import 'package:currency_formatter/currency_formatter.dart';

formatCurrency(String amount){
  CurrencyFormatter cf = CurrencyFormatter();

  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
    symbol: '/=',
    symbolSide: SymbolSide.right,
    thousandSeparator: ',',
    decimalSeparator: '.',
  );

  final formatted = cf.format(amount, euroSettings);

  return formatted;
}