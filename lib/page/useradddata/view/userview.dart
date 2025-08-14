import 'package:flutter/material.dart';
import '../widget/useraddbody.dart';

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
