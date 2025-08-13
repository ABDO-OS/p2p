import 'package:flutter/material.dart';
import '../../core/styles/appstyles.dart';
import '../ReceiptModel/ReceiptModel.dart';
import 'view/receipt_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.selectedBank,
    required this.amount,
    required this.customerName,
  });

  final String selectedBank;
  final String amount;
  final String customerName;

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

  void loadReceipt() {
    final now = DateTime.now();
    setState(() {
      receipt = ReceiptModel(
        date:
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}",
        time:
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
        cardNumber: "442845******6188",
        amount: widget.amount,
        approvalCode: "882806",
        fingerprintVerified: true,
        customerName: widget.customerName,
        bankName: widget.selectedBank,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: receipt == null
            ? const Center(child: CircularProgressIndicator())
            : ReceiptDetails(receipt: receipt!),
      ),
    );
  }
}
