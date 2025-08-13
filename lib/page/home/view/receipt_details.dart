import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../core/styles/appstyles.dart';
import '../../ReceiptModel/ReceiptModel.dart';
import '../../ReceiptModel/print.dart';
import '../widget/receipt_info_row.dart';

class ReceiptDetails extends StatelessWidget {
  final ReceiptModel receipt;

  const ReceiptDetails({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('PTP', style: AppTextStyle.bold50),
            const SizedBox(height: 20),
            ReceiptInfoRow(label: "العميل", value: receipt.customerName),
            const SizedBox(height: 20),
            ReceiptInfoRow(label: "البنك", value: receipt.bankName),
            const SizedBox(height: 20),
            ReceiptInfoRow(label: "تاريخ", value: receipt.date, rtl: false),
            ReceiptInfoRow(label: "الوقت", value: receipt.time, rtl: false),
            const SizedBox(height: 20),
            ReceiptInfoRow(label: "بطاقة الائتمان", value: receipt.cardNumber),
            const SizedBox(height: 20),
            ReceiptInfoRow(label: "مبلغ الشراء", value: receipt.amount),
            const SizedBox(height: 20),
            ReceiptInfoRow(
                label: "Approval Code",
                value: receipt.approvalCode,
                rtl: false),
            const SizedBox(height: 20),
            Text(
              receipt.fingerprintVerified
                  ? "تم التحقق من البصمة"
                  : "البصمة غير متطابقة",
              style: AppTextStyle.medium520,
            ),
            const SizedBox(height: 20),
            Text('باركود', style: AppTextStyle.medium520),
            const SizedBox(height: 5),
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: receipt.approvalCode,
              width: 200,
              height: 80,
              drawText: true,
            ),
            const SizedBox(height: 20),
            Text('شكرا لاستخدامكم PTP', style: AppTextStyle.medium520),
            Text('يرجى الاحتفاظ بالايصال', style: AppTextStyle.medium520),
            Text('نسخه العميل', style: AppTextStyle.medium520),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  printReceipt(receipt, receipt.bankName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "طباعه ايصال الدفع",
                  style: AppTextStyle.medium520.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
