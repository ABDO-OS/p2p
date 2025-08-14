import 'package:fingerprint_auth_example/page/useradddata/logic/user_add_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/simple_button.dart';
import '../../../core/styles/appstyles.dart';

class UserActionButtons extends StatelessWidget {
  final UserAddController controller;

  const UserActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        const SizedBox(height: AppSpacing.xl),
        const SizedBox(height: AppSpacing.xl),

        // Main action button
        SimpleButton(
          text: "تسجيل و حفظ البصمة",
          backgroundColor: AppColors.primary,
          onPressed: () => controller.handleSubmit(context),
          width: double.infinity,
          height: 50,
          icon: Icons.fingerprint_rounded,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Secondary action button
        SimpleButton(
          text: "عرض الإحصائيات",
          backgroundColor: AppColors.primary,
          onPressed: () {
            _showUserStats(context);
          },
          icon: Icons.analytics_outlined,
          width: double.infinity,
          height: 45,
        ),
      ],
    );
  }

  void _showUserStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.analytics_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'إحصائيات المستخدمين',
              style: AppTextStyle.title.copyWith(
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
        content: FutureBuilder<Map<String, dynamic>>(
          future: Future.value(controller.userStats),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text(
                'حدث خطأ في تحميل الإحصائيات',
                style: AppTextStyle.body.copyWith(
                  color: AppColors.error,
                ),
              );
            }

            final stats = snapshot.data ?? {};
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                    'إجمالي المستخدمين', '${stats['totalUsers'] ?? 0}'),
                _buildStatRow('آخر مستخدم', stats['lastUserName'] ?? 'لا يوجد'),
                _buildStatRow('حالة البيانات',
                    stats['hasUsers'] == true ? 'متوفرة' : 'غير متوفرة'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إغلاق',
              style: AppTextStyle.body.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.small.copyWith(
              color: AppColors.gray,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.body.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
