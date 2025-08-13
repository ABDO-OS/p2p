import 'package:fingerprint_auth_example/page/ReceiptModel/ReceiptModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';

import '../useradddata/storage/user_data_service.dart';

Future<void> printReceipt(ReceiptModel receipt, String bankName) async {
  try {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final lastUser = await UserDataService.loadLastUserData();
    final userName = lastUser?['name'] ?? "العميل";

    // Generate barcode as image
    final bc = Barcode.code128();
    final svgBarcode = bc.toSvg(receipt.approvalCode, width: 200, height: 100);

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat(105 * PdfPageFormat.mm, 140 * PdfPageFormat.mm)
                .copyWith(
          marginLeft: 5,
          marginRight: 5,
        ),
        build: (pw.Context context) {
          return pw.Center(
            // This centers the entire column on the page
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
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "$userName : ${receipt.cardNumber}",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "مبلغ الشراء: ${receipt.amount}",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Approval Code: ${receipt.approvalCode}",
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    receipt.fingerprintVerified
                        ? "تم التحقق من البصمة"
                        : "البصمة غير متطابقة",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "عملية مقبولة",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                // pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "بنك $bankName",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                // pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "Thank U for choosing ptp",
                    // style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "باركود",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.SvgImage(svg: svgBarcode, width: 200, height: 80),
                pw.SizedBox(height: 10),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "شكرا لاستخدامكم PTP",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "يرجى الاحتفاظ بالايصال",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    "نسخه العميل",
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Send to printer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    print("Error printing receipt: $e");
  }
}
