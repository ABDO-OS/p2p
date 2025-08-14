import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/styles/appstyles.dart';
import '../../../core/widgets/simple_button.dart';
import '../../../core/routes/navigation_service.dart';
import '../../../core/local_storage/services/selected_banks_service.dart';

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
  List<String> selectedBanks = [];
  List<String> availableBanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeBanks();
  }

  Future<void> _initializeBanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.firsttime) {
        // First time: show all banks, user can select multiple
        availableBanks = banks.map((bank) => bank['name']!).toList();
        selectedBanks = [];
      } else {
        // Second time: show only previously selected banks
        final savedBanks = await SelectedBanksService.getSelectedBanks();
        if (savedBanks.isNotEmpty) {
          availableBanks = savedBanks;
          selectedBanks = [
            savedBanks.first
          ]; // Default to first bank for payment
        } else {
          // Fallback to all banks if no saved selection
          availableBanks = banks.map((bank) => bank['name']!).toList();
          selectedBanks = [];
        }
      }
    } catch (e) {
      print('Error initializing banks: $e');
      // Fallback to all banks
      availableBanks = banks.map((bank) => bank['name']!).toList();
      selectedBanks = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onBankSelected(String bankName) {
    setState(() {
      if (widget.firsttime) {
        // First time: toggle selection (multiple banks allowed)
        if (selectedBanks.contains(bankName)) {
          selectedBanks.remove(bankName);
        } else {
          selectedBanks.add(bankName);
        }
      } else {
        // Second time: single selection for payment
        selectedBanks = [bankName];
      }
    });
    print('Selected banks: $selectedBanks');
  }

  bool _isBankSelected(String bankName) {
    return selectedBanks.contains(bankName);
  }

  Future<void> _handleContinue() async {
    if (selectedBanks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.firsttime
                ? "يرجى اختيار بنك واحد على الأقل"
                : "يرجى اختيار البنك",
            style: AppTextStyle.body.copyWith(
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.firsttime) {
      // Save selected banks for future use
      await SelectedBanksService.saveSelectedBanks(selectedBanks);
      print('Choosebankbody: Saved selected banks: $selectedBanks');

      // Navigate to payment
      await NavigationService.goToPayment(
        customerName: widget.customerName,
      );
    } else {
      // Navigate to home with selected bank
      final selectedBank = selectedBanks.first;
      final customerName = widget.customerName ?? 'العميل';
      print(
          'Choosebankbody: Navigating to home with bank: $selectedBank, customer: $customerName');

      await NavigationService.goToHome(
        selectedBank: selectedBank,
        amount: widget.amount,
        customerName: customerName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.lightGray,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                      widget.firsttime
                          ? 'اختر البنوك المفضلة'
                          : 'اختر البنك للدفع',
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
                    if (widget.firsttime) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'يمكنك اختيار أكثر من بنك',
                        style: AppTextStyle.small.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
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
                  // padding: const EdgeInsets.all(AppSpacing.),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppBorders.medium,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.firsttime
                            ? 'اختر البنوك المفضلة لديك'
                            : 'اختر البنك للدفع',
                        style: AppTextStyle.title.copyWith(
                          color: AppColors.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.firsttime) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'المحدد: ${selectedBanks.length}',
                          style: AppTextStyle.small.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                          itemCount: availableBanks.length,
                          itemBuilder: (context, index) {
                            final bankName = availableBanks[index];
                            final bankData = banks.firstWhere(
                              (bank) => bank['name'] == bankName,
                              orElse: () => {'image': '', 'name': bankName},
                            );
                            final isSelected = _isBankSelected(bankName);

                            return GestureDetector(
                              onTap: () => _onBankSelected(bankName),
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
                                        bankData['image']!,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.account_balance,
                                            size: 30,
                                            color: AppColors.gray,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      bankName,
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
                                    if (widget.firsttime && isSelected) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                    ],
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
                  text: widget.firsttime
                      ? 'حفظ البنوك المفضلة'
                      : 'طباعة وصل الدفع',
                  backgroundColor: AppColors.secondary,
                  onPressed: _handleContinue,
                  icon: widget.firsttime
                      ? Icons.save_rounded
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
