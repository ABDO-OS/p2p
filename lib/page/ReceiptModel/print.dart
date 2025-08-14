import 'package:fingerprint_auth_example/page/ReceiptModel/ReceiptModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';

import '../../core/local_storage/services/user_data_service.dart';
import 'receipt_helpers.dart';

Future<void> printReceipt(ReceiptModel receipt, String bankName) async {
  try {
    final pdf = pw.Document();

    // Load font before building page
    final arabicFont = await PdfGoogleFonts.cairoRegular();

    // Use the customer name from the receipt instead of loading from storage
    final userName =
        receipt.customerName.isNotEmpty ? receipt.customerName : "العميل";

    // Generate barcode
    final bc = Barcode.code128();
    final svgBarcode = bc.toSvg(receipt.approvalCode, width: 230, height: 130);

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat(105 * PdfPageFormat.mm, 140 * PdfPageFormat.mm)
                .copyWith(marginLeft: 5, marginRight: 5),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'PTP',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "${receipt.date}       ${receipt.time}",
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                rtlText("$userName : ${receipt.cardNumber}", font: arabicFont),
                pw.SizedBox(height: 10),
                rtlText("مبلغ الشراء: ${receipt.amount}", font: arabicFont),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Approval Code: ${receipt.approvalCode}",
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                rtlText(
                  receipt.fingerprintVerified
                      ? "تم التحقق من البصمة"
                      : "البصمة غير متطابقة",
                  font: arabicFont,
                ),
                pw.SizedBox(height: 10),
                rtlText("عملية مقبولة", font: arabicFont),
                rtlText("بنك $bankName", font: arabicFont),
                rtlText("Thank U for choosing ptp", font: arabicFont),
                pw.SizedBox(height: 10),
                rtlText("باركود", font: arabicFont),
                pw.SizedBox(height: 5),
                pw.SvgImage(svg: svgBarcode, width: 200, height: 80),
                pw.SizedBox(height: 10),
                rtlText("شكرا لاستخدامكم PTP", font: arabicFont),
                rtlText("يرجى الاحتفاظ بالايصال", font: arabicFont),
                rtlText("نسخه العميل", font: arabicFont),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    print("Error printing receipt: $e");
  }
}
