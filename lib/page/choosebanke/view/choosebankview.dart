import 'package:fingerprint_auth_example/page/choosebanke/widget/choosebankbody.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Choosebankview extends StatelessWidget {
  Choosebankview({super.key, required this.firsttime, required this.amount});
  final String amount;
  bool firsttime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Choosebankbody(
        firsttime: firsttime,
        amount: amount,
      ),
    );
  }
}
