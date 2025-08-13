// models/receipt_model.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReceiptModel {
  final String date;
  final String time;
  final String cardNumber;
  final String amount;
  final String approvalCode;
  final bool fingerprintVerified;

  ReceiptModel({
    required this.date,
    required this.time,
    required this.cardNumber,
    required this.amount,
    required this.approvalCode,
    required this.fingerprintVerified,
  });

  Future<ReceiptModel?> getReceipt() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // returning null triggers default in HomePage
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'cardNumber': cardNumber,
      'amount': amount,
      'approvalCode': approvalCode,
      'fingerprintVerified': fingerprintVerified,
    };
  }

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      date: map['date'],
      time: map['time'],
      cardNumber: map['cardNumber'],
      amount: map['amount'],
      approvalCode: map['approvalCode'],
      fingerprintVerified: map['fingerprintVerified'],
    );
  }
}

Future<void> saveReceipt(ReceiptModel receipt) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('receiptData', jsonEncode(receipt.toMap()));
}

Future<ReceiptModel?> getReceipt() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('receiptData');
  if (jsonString == null) return null;
  return ReceiptModel.fromMap(jsonDecode(jsonString));
}
