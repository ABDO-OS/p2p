import 'package:fingerprint_auth_example/api/local_auth_api.dart';
import 'package:fingerprint_auth_example/main.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../core/routes/navigation_service.dart';
import '../core/local_storage/services/user_data_service.dart';
import '../core/styles/appstyles.dart';

class FingerprintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        body: Container(
          color: AppColors.lightGray,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAvailability(context),
                  const SizedBox(height: AppSpacing.sm),
                  buildAuthenticate(context),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildAvailability(BuildContext context) => buildButton(
        text: 'Check Availability',
        icon: Icons.event_available,
        onClicked: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          final biometrics = await LocalAuthApi.getBiometrics();

          final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText('Biometrics', isAvailable),
                  buildText('Fingerprint', hasFingerprint),
                ],
              ),
            ),
          );
        },
      );

  Widget buildText(String text, bool checked) => Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: AppColors.success, size: 16)
                : Icon(Icons.close, color: AppColors.error, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text(
              text,
              style: AppTextStyle.body.copyWith(
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Authenticate',
        icon: Icons.lock_open,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();
          print('Final result: $isAuthenticated');

          if (isAuthenticated) {
            // Load customer name before navigating
            String customerName = 'العميل';
            try {
              final lastUser = await UserDataService.loadLastUserData();
              if (lastUser != null && lastUser['name'] != null) {
                customerName = lastUser['name']!;
                print('FingerprintPage: Loaded customer name: $customerName');
              }
            } catch (e) {
              print('FingerprintPage: Error loading customer name: $e');
            }

            // Use navigation service instead of direct Navigator
            await NavigationService.replaceWithHome(
              selectedBank: '',
              amount: '',
              customerName: customerName,
            );
          }
        },
      );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppBorders.medium,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClicked,
            borderRadius: AppBorders.medium,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.white, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    text,
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
