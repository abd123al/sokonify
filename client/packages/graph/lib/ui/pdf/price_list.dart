import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../gql/generated/graphql_api.graphql.dart';
import '../pages/inventory/item_tile.dart';
import 'common.dart';

Future<Uint8List> generatePriceList(
  PdfPageFormat pageFormat,
  List<Items$Query$Item> list,
  CurrentStore$Query$Store store,
  Categories$Query$Category pricing,
  bool isInventory,
) async {
  final List<Items$Query$Item> items = list;
  items.sort((a, b) => a.product.name.compareTo(b.product.name));

  final invoice = Invoice(
    store: store,
    pricing: pricing,
    items: items,
    baseColor: PdfColors.teal,
    isInventory: isInventory,
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
    required this.isInventory,
  });

  final List<Items$Query$Item> items;
  final CurrentStore$Query$Store store;
  final Categories$Query$Category pricing;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final bool isInventory;

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
          //if (isInventory) _buildBelow(context),
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
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              child: pw.Text(
                '${pricing.name} ${isInventory ? "Inventory" : "Prices"}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
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
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            poweredBy(),
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
      "Unit Price",
    ];

    final List<List<Object>> data = items.mapIndexed((i, e) {
      List<Object> list = [
        (i + 1),
        "${e.product.name}${e.brand?.name != null ? " (${e.brand?.name})" : ""}",
        (e.unit.name),
        ItemTile.price(e, pricing.id),
      ];

      // final sub = Decimal.parse(ItemTile.price(e, pricing.id)) *
      //     Decimal.fromInt(e.quantity);

      if (isInventory) {
        list.addAll([
          e.quantity,
          //formatCurrency(sub.toString()),
        ]);
      }

      return list;
    }).toList();

    if (isInventory) {
      headers.addAll([
        "Quantity",
        //"Sub Cost",
      ]);
    }

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
        5: pw.Alignment.center,
        6: pw.Alignment.centerRight,
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
}

String _formatDate(DateTime date) {
  final format = DateFormat('d/M/y');
  return format.format(date);
}
