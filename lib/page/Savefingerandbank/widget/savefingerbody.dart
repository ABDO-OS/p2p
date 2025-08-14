import 'package:flutter/material.dart';
import '../../../api/local_auth_api.dart';
import '../../../core/routes/navigation_service.dart';

class Savefingerbody extends StatelessWidget {
  final String? customerName;

  const Savefingerbody({super.key, this.customerName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final isAuthenticated = await LocalAuthApi.authenticate();
                  print('Final result: $isAuthenticated');

                  if (isAuthenticated) {
                    print(
                        'Savefingerbody: Navigating to choose bank with customer name: $customerName');
                    // Use navigation service instead of direct Navigator
                    await NavigationService.replaceWithChooseBank(
                      firsttime: true,
                      amount: '',
                      customerName: customerName,
                    );
                  }
                },
                icon: const Icon(Icons.fingerprint,
                    size: 30, color: Colors.white),
                label: const Text(
                  'تسجيل و حفظ البصمة',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
