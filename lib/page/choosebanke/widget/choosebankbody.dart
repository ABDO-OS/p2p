import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/styles/appstyles.dart';
import '../../../core/widgets/simple_button.dart';
import '../../../core/routes/navigation_service.dart';

class Choosebankbody extends StatefulWidget {
  final bool firsttime;
  final String amount;
  final String? customerName;

  Choosebankbody({
    super.key,
    required this.firsttime,
    required this.amount,
    this.customerName,
  });

  @override
  State<Choosebankbody> createState() => _ChoosebankbodyState();
}

class _ChoosebankbodyState extends State<Choosebankbody> {
  String? selectedBank;

  void _onBankSelected(String bankName) {
    setState(() {
      selectedBank = bankName;
    });
    print('Selected bank: $bankName');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppBorders.medium,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 24,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'اختر البنك',
                      style: AppTextStyle.title.copyWith(
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.customerName != null) ...[
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
                          'مرحباً: ${widget.customerName}',
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

              const SizedBox(height: AppSpacing.sm),

              // Banks grid section
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
                        'اختر البنك المفضل لديك',
                        style: AppTextStyle.title.copyWith(
                          color: AppColors.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: AppSpacing.xs,
                            mainAxisSpacing: AppSpacing.xs,
                          ),
                          itemCount: banks.length,
                          itemBuilder: (context, index) {
                            final bank = banks[index];
                            final isSelected = selectedBank == bank['name'];

                            return GestureDetector(
                              onTap: () => _onBankSelected(bank['name']!),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.lightGray,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.gray.withValues(alpha: 0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: AppBorders.small,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.all(AppSpacing.xs),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: AppBorders.small,
                                      ),
                                      child: Image.asset(
                                        bank['image']!,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      bank['name']!,
                                      style: AppTextStyle.small.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.darkGray,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
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

              // Action button section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppBorders.medium,
                ),
                child: SimpleButton(
                  text: widget.firsttime ? 'حدد البنك' : 'طباعة وصل الدفع',
                  backgroundColor: AppColors.secondary,
                  onPressed: () async {
                    if (widget.firsttime) {
                      print(
                          'Choosebankbody: Navigating to payment with customer name: ${widget.customerName}');
                      await NavigationService.goToPayment(
                          customerName: widget.customerName);
                    } else {
                      if (selectedBank != null) {
                        final customerName = widget.customerName ?? 'العميل';
                        print(
                            'Choosebankbody: Navigating to home with customer name: $customerName');

                        await NavigationService.goToHome(
                          selectedBank: selectedBank!,
                          amount: widget.amount,
                          customerName: customerName,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "يرجى اختيار البنك",
                              style: AppTextStyle.body.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            backgroundColor: AppColors.warning,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  icon: widget.firsttime
                      ? Icons.arrow_forward_rounded
                      : Icons.print_rounded,
                  width: double.infinity,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
