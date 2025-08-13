import 'package:pdf/widgets.dart' as pw;

/// Helper to create RTL Arabic text for PDFs
pw.Widget rtlText(
  String text, {
  required pw.Font font,
  double fontSize = 14,
  bool bold = false,
}) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: fontSize,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}
