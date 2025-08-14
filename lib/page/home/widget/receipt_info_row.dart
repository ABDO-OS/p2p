import 'package:flutter/material.dart';
import '../../../core/styles/appstyles.dart';

class ReceiptInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool rtl;

  const ReceiptInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.rtl = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        rtl ? "$label: $value" : "$label $value",
        style: AppTextStyle.medium520,
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }
}
