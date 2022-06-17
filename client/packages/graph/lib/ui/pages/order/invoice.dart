import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:graph/ui/helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../gql/generated/graphql_api.graphql.dart';

Future<Uint8List> generateInvoice(
  PdfPageFormat pageFormat,
  Order$Query$Order order,
  int id,
  CurrentStore$Query$Store store,
) async {
  final invoice = Invoice(
    store: store,
    order: order,
    invoiceNumber: '$id',
    items: order.orderItems,
    customerName: order.customer?.name ?? "No customer",
    customerAddress: order.customer?.address ?? "",
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.items,
    required this.store,
    required this.order,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Order$Query$Order$OrderItem> items;
  final CurrentStore$Query$Store store;
  final Order$Query$Order order;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  String get _total =>
      items.map<String>((p) => p.price).reduce((a, b) => a + b);

  String get _grandTotal => _total;

  //String? _logo;

  //String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final total = calculateTotal(
      items.map(
        (e) => TotalPriceArgs(
          price: e.price,
          quantity: e.quantity,
        ),
      ),
    );

    // Create a PDF document.
    final doc = pw.Document();

    //_logo = await rootBundle.loadString('assets/logo.png');
    //_bgShape = await rootBundle.loadString('assets/logo.png');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        header: _buildHeader,
        footer: _buildFooter,
        margin: const pw.EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 48,
        ),
        build: (context) => [
          _contentHeader(context, total),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context, total),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Column(
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
                'Invoice/Delivery Note',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Powered by Sokonify',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.Widget _contentHeader(pw.Context context, String total) {
    const height = 80.0;
    const padding = pw.EdgeInsets.all(8);
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        bottom: 16,
        top: 8,
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.DecoratedBox(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black,
                ),
              ),
              child: pw.SizedBox(
                height: height,
                child: pw.Padding(
                  padding: padding,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Bill to:"),
                      pw.Text(
                        customerName,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(customerAddress),
                    ],
                  ),
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(
                  pw.Radius.circular(2),
                ),
              ),
              alignment: pw.Alignment.centerLeft,
              height: height,
              child: pw.DefaultTextStyle(
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
                child: pw.DecoratedBox(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  child: pw.Padding(
                    padding: padding,
                    child: pw.GridView(
                      crossAxisCount: 2,
                      children: [
                        pw.Text('Invoice Number:'),
                        pw.Text(invoiceNumber),
                        pw.Text('Date Created:'),
                        pw.Text(_formatDate(order.createdAt)),
                        pw.Text('TIN:'),
                        pw.Text(store.tin ?? ""),
                        pw.Text('Total Amount:'),
                        pw.Text(total),
                        pw.Text('Payment Status:'),
                        pw.Text(describeEnum(order.status).toUpperCase()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _contentFooter(pw.Context context, String total) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Order Prepared by: ${order.staff.name}"),
              pw.Text('Signature.........................'),
              pw.SizedBox(height: 8),
              if (order.payment != null) ...[
                pw.Text("Payment Processed by: ${order.payment!.staff.name}"),
                pw.Text('Signature.........................'),
              ]
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(total),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Discount:'),
                    pw.Text(formatCurrency("0.00")),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Tax:'),
                    pw.Text(formatCurrency("0.00")),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(total),
                    ],
                  ),
                ),
                pw.Divider(color: accentColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                // decoration: pw.BoxDecoration(
                //   border: pw.Border(top: pw.BorderSide(color: accentColor)),
                // ),
                //padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                store.terms ?? "Your terms will appear here.",
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 10,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
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
        color: _baseTextColor,
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
        "Unit",
        "Unit Price",
        "Quantity",
        "Total",
      ],
      data: items
          .map((e) => [
                "${e.item.product.name} ${e.item.brand?.name ?? ""}",
                e.item.unit.name,
                formatCurrency(e.price),
                e.quantity,
                formatCurrency(e.subTotalPrice),
              ])
          .toList(),
    );
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}
