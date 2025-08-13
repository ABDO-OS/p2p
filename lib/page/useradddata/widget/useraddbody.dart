import 'package:fingerprint_auth_example/page/useradddata/logic/user_add_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/customebottom.dart';
import 'user_form_widget.dart';
import 'user_action_buttons.dart';

class Useraddbody extends StatefulWidget {
  const Useraddbody({super.key});

  @override
  State<Useraddbody> createState() => _UseraddbodyState();
}

class _UseraddbodyState extends State<Useraddbody> {
  final _controller = UserAddController();

  @override
  void initState() {
    super.initState();
    _controller.initializeData(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري التحميل...'),
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            UserFormWidget(
              formKey: _controller.formKey,
              nameController: _controller.nameController,
              emailController: _controller.emailController,
              phoneController: _controller.phoneController,
              addressController: _controller.addressController,
              ageController: _controller.ageController,
              showSecurityInfo: true,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "تسجيل و حفظ البصمة",
              textColor: Colors.white,
              onTap: () => _controller.handleSubmit(context),
            ),
            const SizedBox(height: 15),
            UserActionButtons(controller: _controller),
          ],
        ),
      ),
    );
  }
}
