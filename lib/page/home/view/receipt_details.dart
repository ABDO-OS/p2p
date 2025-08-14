import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../core/styles/appstyles.dart';
import '../../ReceiptModel/ReceiptModel.dart';
import '../../ReceiptModel/print.dart';
import '../widget/receipt_info_row.dart';
import '../../../core/widgets/simple_button.dart';

class ReceiptDetails extends StatelessWidget {
  final ReceiptModel receipt;

  const ReceiptDetails({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    print(
        'ReceiptDetails: Building with customerName: "${receipt.customerName}"');
    print('ReceiptDetails: Building with bankName: "${receipt.bankName}"');
    print('ReceiptDetails: Building with amount: "${receipt.amount}"');

    return Container(
      color: AppColors.lightGray,
      child: SingleChildScrollView(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 24,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'PTP',
                    style: AppTextStyle.title.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'وصل الدفع',
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Receipt content section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppBorders.medium,
              ),
              child: Column(
                children: [
                  // Customer and bank info
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: AppBorders.small,
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        ReceiptInfoRow(
                          label: "العميل",
                          value: receipt.customerName,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ReceiptInfoRow(
                          label: "البنك",
                          value: receipt.bankName,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Date and time info
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: AppBorders.small,
                      border: Border.all(
                        color: AppColors.gray.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        ReceiptInfoRow(
                          label: "تاريخ",
                          value: receipt.date,
                          rtl: false,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ReceiptInfoRow(
                          label: "الوقت",
                          value: receipt.time,
                          rtl: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Payment details
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: AppBorders.small,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        ReceiptInfoRow(
                          label: "بطاقة الائتمان",
                          value: receipt.cardNumber,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ReceiptInfoRow(
                          label: "مبلغ الشراء",
                          value: receipt.amount,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ReceiptInfoRow(
                          label: "Approval Code",
                          value: receipt.approvalCode,
                          rtl: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Fingerprint verification status
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: receipt.fingerprintVerified
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius: AppBorders.small,
                      border: Border.all(
                        color: receipt.fingerprintVerified
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          receipt.fingerprintVerified
                              ? Icons.verified_rounded
                              : Icons.error_outline_rounded,
                          color: receipt.fingerprintVerified
                              ? AppColors.success
                              : AppColors.error,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          receipt.fingerprintVerified
                              ? "تم التحقق من البصمة"
                              : "البصمة غير متطابقة",
                          style: AppTextStyle.body.copyWith(
                            color: receipt.fingerprintVerified
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Barcode section
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: AppBorders.small,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'باركود',
                          style: AppTextStyle.title.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: AppBorders.small,
                          ),
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: receipt.approvalCode,
                            width: 200,
                            height: 80,
                            drawText: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Footer messages
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppBorders.small,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'شكرا لاستخدامكم PTP',
                          style: AppTextStyle.title.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'يرجى الاحتفاظ بالايصال',
                          style: AppTextStyle.body.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'نسخه العميل',
                          style: AppTextStyle.body.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Print button section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppBorders.medium,
              ),
              child: SimpleButton(
                text: "طباعة وصل الدفع",
                backgroundColor: AppColors.accent,
                onPressed: () {
                  printReceipt(receipt, receipt.bankName);
                },
                icon: Icons.print_rounded,
                width: double.infinity,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
