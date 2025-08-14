import 'package:flutter/material.dart';
import '../../../api/local_auth_api.dart';
import '../../../core/routes/navigation_service.dart';
import '../../../core/widgets/simple_button.dart';
import '../../../core/styles/appstyles.dart';

class Savefingerbody extends StatelessWidget {
  final String? customerName;

  const Savefingerbody({super.key, this.customerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              // Header section
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppBorders.medium,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          size: 50,
                          color: AppColors.white,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'تسجيل البصمة',
                          style: AppTextStyle.title.copyWith(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'سيتم تسجيل بصمتك للمصادقة الآمنة',
                          style: AppTextStyle.small.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (customerName != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: AppBorders.small,
                            ),
                            child: Text(
                              'مرحباً: $customerName',
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Action section
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppBorders.medium,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اضغط على الزر أدناه لتسجيل بصمتك',
                        style: AppTextStyle.title.copyWith(
                          color: AppColors.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SimpleButton(
                        text: 'تسجيل و حفظ البصمة',
                        backgroundColor: AppColors.secondary,
                        onPressed: () async {
                          final isAuthenticated =
                              await LocalAuthApi.authenticate();
                          print('Final result: $isAuthenticated');

                          if (isAuthenticated) {
                            print(
                                'Savefingerbody: Navigating to choose bank with customer name: $customerName');
                            await NavigationService.replaceWithChooseBank(
                              firsttime: true,
                              amount: '',
                              customerName: customerName,
                            );
                          }
                        },
                        icon: Icons.fingerprint_rounded,
                        width: double.infinity,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
