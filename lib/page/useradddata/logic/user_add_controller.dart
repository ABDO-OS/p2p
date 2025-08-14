import 'package:flutter/material.dart';
import '../../../core/local_storage/services/user_data_service.dart';
import '../../../core/splash/loading_dialog_widget.dart';
import '../../../core/routes/navigation_service.dart';

class UserAddController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();

  bool _isLoading = false;
  Map<String, dynamic> userStats = {};

  bool get isLoading => _isLoading;

  Future<void> initializeData(BuildContext context) async {
    print('UserAddController: Starting initialization...');
    _isLoading = true;
    notifyListeners();

    try {
      // Add a simple delay to simulate loading
      await Future.delayed(const Duration(milliseconds: 500));

      print('UserAddController: Loading user stats...');
      try {
        userStats = await UserDataService.getUserStats();
        print('UserAddController: User stats loaded: $userStats');
      } catch (e) {
        print('UserAddController: Error loading user stats: $e');
        userStats = {
          'totalUsers': 0,
          'hasUsers': false,
          'lastUser': null,
          'lastUserName': 'لا يوجد',
        };
      }

      print('UserAddController: Loading last user data...');
      try {
        final lastUser = await UserDataService.loadLastUserData();
        print('UserAddController: Last user data: $lastUser');

        if (lastUser != null) {
          print(
              'UserAddController: Populating controllers with last user data...');
          UserDataService.populateControllers(
            userData: lastUser,
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            addressController: addressController,
            ageController: ageController,
          );
          print('UserAddController: Controllers populated successfully');
        } else {
          print('UserAddController: No last user data found');
        }
      } catch (e) {
        print('UserAddController: Error loading last user data: $e');
        // Continue with empty form
      }
    } catch (e) {
      print('UserAddController: General error during initialization: $e');
      // Don't show error snackbar, just log it and continue
      print('UserAddController: Continuing with empty form due to error');
    } finally {
      print(
          'UserAddController: Initialization complete, setting loading to false');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final userData = UserDataService.createUserDataMap(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      addressController: addressController,
      ageController: ageController,
    );

    final validationError = UserDataService.validateUserData(
      name: userData['name']!,
      email: userData['email']!,
      phone: userData['phone']!,
      address: userData['address']!,
      age: userData['age']!,
    );

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    LoadingDialog.show(context, message: 'جاري حفظ البيانات...');

    try {
      await UserDataService.saveUserData(
        name: userData['name']!,
        email: userData['email']!,
        phone: userData['phone']!,
        address: userData['address']!,
        age: userData['age']!,
      );

      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
      );

      clearForm();

      // Pass the user's name through navigation to ensure it's available
      final customerName = userData['name']!;
      print(
          'UserAddController: Navigating to save fingerprint with customer name: $customerName');

      // Use navigation service instead of direct Navigator
      await NavigationService.goToSaveFingerprint(customerName: customerName);
    } catch (_) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في حفظ البيانات')),
      );
    }
  }

  void clearForm() {
    UserDataService.clearControllers(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      addressController: addressController,
      ageController: ageController,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
