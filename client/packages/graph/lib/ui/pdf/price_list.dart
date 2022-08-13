import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../gql/generated/graphql_api.graphql.dart';
import '../pages/inventory/item_tile.dart';

Future<Uint8List> generatePriceList(
  PdfPageFormat pageFormat,
  List<Items$Query$Item> list,
  CurrentStore$Query$Store store,
    Categories$Query$Category pricing,
) async {
  final List<Items$Query$Item> items = list;
  items.sort((a, b) => a.product.name.compareTo(b.product.name));

  final invoice = Invoice(
    store: store,
    pricing: pricing,
    items: items,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.items,
    required this.store,
    required this.baseColor,
    required this.pricing,
    required this.accentColor,
  });

  final List<Items$Query$Item> items;
  final CurrentStore$Query$Store store;
  final Categories$Query$Category pricing;
  final PdfColor baseColor;
  final PdfColor accentColor;

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
            '${pricing.name} Prices',
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
        pw.Text(
          'Signature ..................................',
          style: const pw.TextStyle(
            fontSize: 12,
          ),
        ),
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
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
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
      headers: [
        "Item Name",
        "Brand",
        "Quantity",
        "Unit Price",
      ],
      data: items
          .map((e) => [
                (e.product.name),
                (e.brand?.name ?? ""),
                e.quantity,
                ItemTile.price(e, pricing.id),
              ])
          .toList(),
    );
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat('d/M/y').add_Hms();
  return format.format(date);
}
