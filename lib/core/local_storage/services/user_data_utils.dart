// core/services/user_data/user_data_utils.dart
import 'package:flutter/material.dart';

class UserDataUtils {
  static void clearControllers({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    ageController.clear();
  }

  static void populateControllers({
    required Map<String, String> userData,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    nameController.text = userData['name'] ?? '';
    emailController.text = userData['email'] ?? '';
    phoneController.text = userData['phone'] ?? '';
    addressController.text = userData['address'] ?? '';
    ageController.text = userData['age'] ?? '';
  }

  static Map<String, String> createUserDataMap({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'age': ageController.text.trim(),
    };
  }
}
