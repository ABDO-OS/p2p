import 'package:flutter/material.dart';
import '../../../core/textfield.dart';

/// A reusable form widget for user data input
class UserFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController ageController;
  final bool showSecurityInfo;

  const UserFormWidget({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.ageController,
    this.showSecurityInfo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Title
          const Text(
            'ادخل بياناتك',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Security info container
          if (showSecurityInfo)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'بياناتك محفوظة بشكل آمن ومشفر',
                      style: TextStyle(
                          color: Color.fromARGB(255, 78, 78, 78), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Name field
          Textfield(
            hinttext: "ادخل اسمك",
            controller: nameController,
            validator: (value) =>
                value == null || value.trim().isEmpty ? "الاسم مطلوب" : null,
          ),
          const SizedBox(height: 15),

          // Email field
          Textfield(
            hinttext: "ادخل الايميل",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return "الايميل مطلوب";
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                return "ادخل ايميل صحيح";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Phone field
          Textfield(
            hinttext: "ادخل رقمك",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value == null || value.trim().isEmpty ? "الرقم مطلوب" : null,
          ),
          const SizedBox(height: 15),

          // Address field
          Textfield(
            hinttext: "ادخل عنوانك",
            controller: addressController,
            validator: (value) =>
                value == null || value.trim().isEmpty ? "العنوان مطلوب" : null,
          ),
          const SizedBox(height: 15),

          // Age field
          Textfield(
            hinttext: "ادخل عمرك",
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return "العمر مطلوب";
              final age = int.tryParse(value.trim());
              if (age == null) return "ادخل رقماً صحيحاً";
              if (age < 1 || age > 150) return "ادخل عمراً صحيحاً";
              return null;
            },
          ),
        ],
      ),
    );
  }
}
