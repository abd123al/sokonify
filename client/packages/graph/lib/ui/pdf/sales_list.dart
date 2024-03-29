import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../gql/generated/graphql_api.graphql.dart';
import '../helpers/currency_formatter.dart';

Future<Uint8List> generateSalesList(
  PdfPageFormat pageFormat,
  List<Sales$Query$OrderItem> list,
  CurrentStore$Query$Store store,
  String word,
) async {
  final List<Sales$Query$OrderItem> items = list;
  items.sort((a, b) => a.item.product.name.compareTo(b.item.product.name));

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

  final List<Sales$Query$OrderItem> items;
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
           _buildBelow(context),
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
            '$word Sales',
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
      "#",
      "Item Name",
      "Unit",
      "Quantity",
      "Unit Price",
      "Sub Total",
    ];

    final List<List<Object>> data = items.mapIndexed((i, e) {
      List<Object> list = [
        (i + 1),
        "${e.item.product.name}${e.item.brand?.name != null ? " (${e.item.brand?.name})" : ""}",
        (e.item.unit.name),
        e.quantity,
        e.price,
        e.subTotalPrice,
      ];

      return list;
    }).toList();

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
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
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

  pw.Widget _buildBelow(pw.Context context) {
    final total = calculateTotal(
      items.map(
        (e) => TotalPriceArgs(
          price: e.subTotalPrice,
          quantity: 1,
        ),
      ),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(child: pw.SizedBox(height: 4)),
            pw.Container(
              child: pw.Text(
                'Total Sales',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
            pw.SizedBox(width: 32),
            pw.Container(
              child: pw.Text(
                total,
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
}

String _formatDate(DateTime date) {
  final format = DateFormat('d/M/y').add_Hms();
  return format.format(date);
}
