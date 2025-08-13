import 'package:flutter/material.dart';
import '../../api/local_auth_api.dart';
import '../choosebanke/view/choosebankview.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String amount = "0.00";
  final TextEditingController nameController = TextEditingController();

  final List<String> keys = [
    '3',
    '2',
    '1',
    '6',
    '5',
    '4',
    '9',
    '8',
    '7',
    'back',
    '0',
    '.',
  ];

  void onKeyTap(String key) {
    setState(() {
      if (key == 'back') {
        // Delete last character
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
          if (amount.isEmpty) amount = "0";
        }
      } else {
        // Append digit or dot
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
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top bank info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/images/rajhi.png', // Your logo
                  //   height: 40,
                  //   width: 40,
                  // ),
                  const SizedBox(width: 8),
                  const Text(
                    'ادخل المبلغ',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount display
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(Icons.currency_ruble, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Numeric keypad
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: keys.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    String key = keys[index];
                    return GestureDetector(
                      onTap: () => onKeyTap(key),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: key == 'back'
                              ? const Icon(Icons.backspace_outlined)
                              : Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pay button
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
                                  firsttime: false,
                                  amount: amount,
                                )),
                      );
                    }
                  },
                  icon: const Icon(Icons.fingerprint,
                      size: 30, color: Colors.white),
                  label: const Text(
                    'ادفع',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
