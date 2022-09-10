import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:graph/ui/helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../gql/generated/graphql_api.graphql.dart';

Future<Uint8List> generateDailyStats(
  PdfPageFormat pageFormat,
  DailyStats$Query data,
  CurrentStore$Query$Store store,
  String word,
) async {
  final List<DailyStats$Query$Profit> items = data.dailyGrossProfits;
  items.sort((a, b) => b.day.compareTo(a.day));

  final invoice = Invoice(
    store: store,
    items: items,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
    word: word,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.items,
    required this.store,
    required this.baseColor,
    required this.accentColor,
    required this.word,
  });

  final List<DailyStats$Query$Profit> items;
  final CurrentStore$Query$Store store;
  final PdfColor baseColor;
  final PdfColor accentColor;
  String word;

  static const _darkColor = PdfColors.blueGrey800;

  final borderRadius = const pw.BorderRadius.all(pw.Radius.circular(2));

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        footer: _buildFooter,
        margin: const pw.EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 48,
        ),
        build: (context) => [
          _buildHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          // _buildBelow(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  store.name,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                pw.Text(
                  store.description ??
                      "Your facility \ndescription \nwill appear here...",
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            pw.Container(
              width: 80,
              height: 80,
              child: pw.Text(""),
            )
          ],
        ),
        pw.Divider(),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(
            '$word Daily Stats'.cleanSpaces(),
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              child: pw.Text(
                'Powered by Sokonify',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
            pw.Container(
              child: pw.Text(
                _formatDate(DateTime.now()),
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            pw.Container(
              child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    List<String> headers = [
      "Date",
      "Total Sales",
      "Gross Profit",
    ];

    List<List<Object>> data = items.mapIndexed((i, e) {
      List<Object> list = [
        _formatDailyDate(e.day),
        formatCurrency(e.sales),
        formatCurrency(e.real),
      ];

      return list;
    }).toList();

    final totalProfit = calculateTotal(
      items.map(
        (e) => TotalPriceArgs(
          price: e.real,
          quantity: 1, //hack
        ),
      ),
    );

    final totalSales = calculateTotal(
      items.map(
        (e) => TotalPriceArgs(
          price: e.sales,
          quantity: 1, //hack
        ),
      ),
    );

    final profitArr = items.map((e) => e.real);
    final salesArr = items.map((e) => e.sales);

    final salesAvg = calculateAvg(salesArr);
    final profitAvg = calculateAvg(profitArr);

    final List<Object> empties = ["", "", ""];
    final List<Object> averages = ["Average", salesAvg, profitAvg];
    final List<Object> totals = ["Total", totalSales, totalProfit];

    data.add(empties);
    data.add(averages);
    data.add(totals);

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: _darkColor,
        ),
        borderRadius: borderRadius,
      ),
      headerHeight: 25,
      cellHeight: 20,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: headers,
      data: data,
    );
  }

  String _formatDailyDate(DateTime date) {
    final format = DateFormat('dd/MM/y EEEE');
    return format.format(date);
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat('d/M/y').add_Hms();
  return format.format(date);
}
