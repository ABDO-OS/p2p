import 'package:flutter/material.dart';
import '../../../api/local_auth_api.dart';
import '../../choosebanke/view/choosebankview.dart';

class Savefingerbody extends StatelessWidget {
  const Savefingerbody({super.key});

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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => Choosebankview(
                                firsttime: true,
                                amount: '',
                              )),
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
