import 'package:fingerprint_auth_example/core/styles/appstyles.dart';
import 'package:flutter/material.dart';
import '../../api/local_auth_api.dart';
import '../../core/constants.dart';
import '../../core/routes/navigation_service.dart';
import '../../core/widgets/simple_button.dart';
import '../../core/local_storage/services/selected_banks_service.dart';

class PaymentScreen extends StatefulWidget {
  final String? customerName;

  const PaymentScreen({super.key, this.customerName});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String amount = "0.00";
  final TextEditingController nameController = TextEditingController();

  void onKeyTap(String key) {
    setState(() {
      if (key == 'back') {
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
          if (amount.isEmpty) amount = "0";
        }
      } else {
        if (amount == "0.00" || amount == "0") {
          amount = key == '.' ? "0." : key;
        } else {
          amount += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.lightGray,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Column(
              children: [
                // Amount display section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppBorders.medium,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'المبلغ المطلوب',
                        style: AppTextStyle.title.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: AppBorders.medium,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                amount,
                                style: AppTextStyle.title.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.currency_ruble_rounded,
                              size: 24,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Numeric keypad section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppBorders.medium,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'أدخل المبلغ',
                          style: AppTextStyle.title.copyWith(
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: keys.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: AppSpacing.xs,
                              mainAxisSpacing: AppSpacing.xs,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              String key = keys[index];
                              return GestureDetector(
                                onTap: () => onKeyTap(key),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: key == 'back'
                                        ? AppColors.warning
                                            .withValues(alpha: 0.1)
                                        : AppColors.primary
                                            .withValues(alpha: 0.1),
                                    borderRadius: AppBorders.small,
                                    border: Border.all(
                                      color: key == 'back'
                                          ? AppColors.warning
                                              .withValues(alpha: 0.3)
                                          : AppColors.primary
                                              .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: key == 'back'
                                        ? Icon(
                                            Icons.backspace_outlined,
                                            color: AppColors.warning,
                                            size: 20,
                                          )
                                        : Text(
                                            key,
                                            style: AppTextStyle.title.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Pay button section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppBorders.medium,
                  ),
                  child: SimpleButton(
                    text: 'ادفع',
                    backgroundColor: AppColors.accent,
                    onPressed: () async {
                      final isAuthenticated = await LocalAuthApi.authenticate();
                      print('Final result: $isAuthenticated');

                      if (isAuthenticated) {
                        final customerName = widget.customerName ?? 'العميل';
                        print(
                            'PaymentScreen: Navigating to choose bank with customer name: $customerName');

                        // Save the amount for the next step
                        // The bank selection will be handled in the choose bank screen
                        await NavigationService.replaceWithChooseBank(
                          firsttime: false,
                          amount: amount,
                          customerName: customerName,
                        );
                      }
                    },
                    icon: Icons.fingerprint_rounded,
                    width: double.infinity,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
