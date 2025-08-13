import 'package:flutter/material.dart';

import '../../../core/customebottom.dart';
import '../../../core/customecard.dart';
import '../../entermony/entermony.dart';
import '../../home_page.dart';

class Choosebankbody extends StatefulWidget {
  final bool firsttime;
  final String amount; // <-- add this

  Choosebankbody({
    super.key,
    required this.firsttime,
    required this.amount,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'اختار البنك',
            style: TextStyle(fontSize: 35),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 110 / 140,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                final isSelected = selectedBank == bank['name'];

                return GestureDetector(
                  onTap: () => _onBankSelected(bank['name']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          bank['image']!,
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bank['name']!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          widget.firsttime
              ? CustomButton(
                  text: 'حدد البنك',
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ),
                    );
                  },
                )
              : CustomButton(
                  text: 'طباعه وصل الدفع',
                  textColor: Colors.white,
                  onTap: () {
                    if (selectedBank != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            selectedBank: selectedBank!,
                            amount: widget.amount,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("يرجى اختيار البنك")),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> banks = [
  {'image': 'assets/images/rajhi.png', 'name': 'الراجحي'},
  {'image': 'assets/images/Alinma.png', 'name': 'الإنماء'},
  {'image': 'assets/images/sab.png', 'name': 'ساب'},
  {'image': 'assets/images/p2p.jpg', 'name': 'p2p'},
  {'image': 'assets/images/jazera.png', 'name': 'الجزيرة'},
  {'image': 'assets/images/stcbank.png', 'name': 'اس تي سي'},
  {'image': 'assets/images/barq.png', 'name': 'برق'},
  {'image': 'assets/images/D360.jpg', 'name': 'D360'},
  {'image': 'assets/images/tekmo.png', 'name': 'تكمو'},
];
