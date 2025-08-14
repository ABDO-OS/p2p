import 'package:flutter/material.dart';
import '../../../core/styles/appstyles.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorders.medium,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // const SizedBox(height: AppSpacing.lgx),
            // Simple header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    size: 24,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'أدخل بياناتك',
                    style: AppTextStyle.title.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Form fields container
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                children: [
                  // if (showSecurityInfo)
                  //   Container(
                  //     padding: const EdgeInsets.all(AppSpacing.xs),
                  //     margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.secondary.withValues(alpha: 0.1),
                  //       borderRadius: AppBorders.small,
                  //       border: Border.all(
                  //         color: AppColors.secondary.withValues(alpha: 0.3),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.security_rounded,
                  //           color: AppColors.secondary,
                  //           size: 16,
                  //         ),
                  //         const SizedBox(width: AppSpacing.sm),
                  //         Expanded(
                  //           child: Text(
                  //             'بياناتك محفوظة بشكل آمن ومشفر',
                  //             style: AppTextStyle.small.copyWith(
                  //               color: AppColors.secondary,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),

                  // Name field - Simple TextFormField
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "ادخل اسمك",
                      labelText: "الاسم",
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: AppBorders.small,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "الاسم مطلوب"
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Email field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "ادخل الايميل",
                      labelText: "البريد الإلكتروني",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: AppBorders.small,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "الايميل مطلوب";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value.trim())) {
                        return "ادخل ايميل صحيح";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Phone field
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: "ادخل رقمك",
                      labelText: "رقم الهاتف",
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: AppBorders.small,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "الرقم مطلوب"
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Address field
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "ادخل عنوانك",
                      labelText: "العنوان",
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: AppBorders.small,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "العنوان مطلوب"
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Age field
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      hintText: "ادخل عمرك",
                      labelText: "العمر",
                      prefixIcon: Icon(
                        Icons.cake_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: AppBorders.small,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "العمر مطلوب";
                      final age = int.tryParse(value.trim());
                      if (age == null) return "ادخل رقماً صحيحاً";
                      if (age < 1 || age > 150) return "ادخل عمراً صحيحاً";
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
