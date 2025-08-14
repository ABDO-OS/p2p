import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/styles/appstyles.dart';
import '../../../core/widgets/customebottom.dart';
import '../../../core/routes/navigation_service.dart';
import '../../../core/local_storage/services/user_data_service.dart';

class Choosebankbody extends StatefulWidget {
  final bool firsttime;
  final String amount;

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
  String? customerName;

  @override
  void initState() {
    super.initState();
    _loadCustomerName();
  }

  Future<void> _loadCustomerName() async {
    try {
      final lastUser = await UserDataService.loadLastUserData();
      if (lastUser != null && lastUser['name'] != null) {
        setState(() {
          customerName = lastUser['name']!;
        });
        print('Choosebankbody: Loaded customer name: $customerName');
      } else {
        print('Choosebankbody: No customer name found, using default');
        setState(() {
          customerName = 'العميل';
        });
      }
    } catch (e) {
      print('Choosebankbody: Error loading customer name: $e');
      setState(() {
        customerName = 'العميل';
      });
    }
  }

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
          Text('اختار البنك', style: AppTextStyle.bold30),
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
          CustomButton(
            text: widget.firsttime ? 'حدد البنك' : 'طباعه وصل الدفع',
            textColor: Colors.white,
            onTap: () async {
              if (widget.firsttime) {
                // Use navigation service instead of direct Navigator
                await NavigationService.goToPayment();
              } else {
                if (selectedBank != null) {
                  // Use navigation service instead of direct Navigator
                  await NavigationService.goToHome(
                    selectedBank: selectedBank!,
                    amount: widget.amount,
                    customerName: customerName ?? 'العميل',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("يرجى اختيار البنك")),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
