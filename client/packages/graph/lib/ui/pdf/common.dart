import 'package:pdf/widgets.dart' as pw;

poweredBy() {
  return pw.Container(
    child: pw.Text(
      'Powered by Sokonify: +255687356518',
      style: pw.TextStyle(
        fontSize: 12,
        fontStyle: pw.FontStyle.italic,
      ),
    ),
  );
}
