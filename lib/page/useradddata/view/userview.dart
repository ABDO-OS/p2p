import 'package:flutter/material.dart';
import '../../../core/styles/appstyles.dart';
import '../widget/useraddbody.dart';

class Userview extends StatelessWidget {
  const Userview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Useraddbody(),
      ),
      backgroundColor: AppColors.lightGray,
    );
  }
}
