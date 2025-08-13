import 'package:flutter/material.dart';
import '../../../core/local_storage/services/user_data_service.dart';
import '../../../core/splash/loading_dialog_widget.dart';
import '../../Savefingerandbank/view/savefingerview.dart';

class UserAddController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();

  bool isLoading = false;
  Map<String, dynamic> userStats = {};

  Future<void> initializeData(BuildContext context) async {
    isLoading = true;

    try {
      userStats = await UserDataService.getUserStats();
      final lastUser = await UserDataService.loadLastUserData();
      if (lastUser != null) {
        UserDataService.populateControllers(
          userData: lastUser,
          nameController: nameController,
          emailController: emailController,
          phoneController: phoneController,
          addressController: addressController,
          ageController: ageController,
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في تحميل البيانات')),
      );
    }

    isLoading = false;
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final userData = UserDataService.createUserDataMap(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      addressController: addressController,
      ageController: ageController,
    );

    final validationError = UserDataService.validateUserData(
      name: userData['name']!,
      email: userData['email']!,
      phone: userData['phone']!,
      address: userData['address']!,
      age: userData['age']!,
    );

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    LoadingDialog.show(context, message: 'جاري حفظ البيانات...');

    try {
      await UserDataService.saveUserData(
        name: userData['name']!,
        email: userData['email']!,
        phone: userData['phone']!,
        address: userData['address']!,
        age: userData['age']!,
      );

      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
      );

      clearForm();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Savefingerview()),
      );
    } catch (_) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في حفظ البيانات')),
      );
    }
  }

  void clearForm() {
    UserDataService.clearControllers(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      addressController: addressController,
      ageController: ageController,
    );
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    ageController.dispose();
  }
}
