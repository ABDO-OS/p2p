import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import '../core/appstyles.dart';
import 'ReceiptModel/ReceiptModel.dart';
import 'ReceiptModel/print.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.selectedBank, required this.amount});
  final String selectedBank;

  final String amount;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReceiptModel? receipt;

  @override
  void initState() {
    super.initState();
    loadReceipt();
  }

  Future<void> loadReceipt() async {
    // For now using default data
    setState(() {
      final now = DateTime.now();
      receipt = ReceiptModel(
        date:
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}",
        time:
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
        cardNumber: "442845******6188",
        amount: widget.amount,
        // amount: "SAR 104.09",
        approvalCode: "882806",
        fingerprintVerified: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: receipt == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20), // padding on the scroll
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          receipt!.fingerprintVerified
                              ? "Fingerprint Verified"
                              : "Fingerprint Not Verified",
                          style: AppTextStyle.medium520,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${receipt!.date}    ${receipt!.time}",
                          style: AppTextStyle.medium520,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "بطاقة الأتمان: ${receipt!.cardNumber}",
                          style: AppTextStyle.medium520,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "مبلغ الشراء: ${receipt!.amount}",
                          style: AppTextStyle.medium520,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Approval Code: ${receipt!.approvalCode}",
                          style: AppTextStyle.medium520,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('تم التحقق من البصمة',
                          style: AppTextStyle.medium520),
                      const SizedBox(height: 20),
                      Text('باركود', style: AppTextStyle.medium520),
                      const SizedBox(height: 5),
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: receipt!.approvalCode,
                        width: 200,
                        height: 80,
                        drawText: true,
                      ),
                      const SizedBox(height: 20),
                      Text('شكرا لاستخدامكم PTP',
                          style: AppTextStyle.medium520),
                      Text('يرجى الاحتفاظ بالايصال',
                          style: AppTextStyle.medium520),
                      Text('نسخه العميل', style: AppTextStyle.medium520),
                      const SizedBox(height: 20),
                      Container(
                        width: 300,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            printReceipt(receipt!, widget.selectedBank);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 6,
                            // maximumSize: const Size(30, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "طباعه ايصال الدفع",
                            style: AppTextStyle.medium520
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
