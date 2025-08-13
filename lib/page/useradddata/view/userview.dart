import 'package:fingerprint_auth_example/page/useradddata/widget/useraddbody.dart';
import 'package:flutter/material.dart';

class Userview extends StatelessWidget {
  const Userview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Useraddbody(),
      backgroundColor: Colors.white,
    );
  }
}
