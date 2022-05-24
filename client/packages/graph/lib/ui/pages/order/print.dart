import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'invoice.dart';

class PrintPage extends StatelessWidget {
  const PrintPage({
    Key? key,
    required this.id,
    required this.order,
  }) : super(key: key);

  final int id;
  final Order$Query$Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print"),
      ),
      body: PdfPreview(
        canDebug: kDebugMode,
        pdfFileName: "invoice_$id.pdf",
        initialPageFormat: PdfPageFormat.a4,
        build: (PdfPageFormat format) {
          return generateInvoice(format, order, id);
        },
      ),
    );
  }
}
