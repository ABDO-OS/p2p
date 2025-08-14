import 'package:fingerprint_auth_example/page/Savefingerandbank/widget/savefingerbody.dart';
import 'package:flutter/material.dart';

class Savefingerview extends StatelessWidget {
  final String? customerName;

  const Savefingerview({super.key, this.customerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Savefingerbody(customerName: customerName),
    );
  }
}
