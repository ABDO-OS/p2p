import 'package:flutter/material.dart';
import '../../../core/customebottom.dart';
import '../../Savefingerandbank/view/savefingerview.dart';
import '../storage/user_data_service.dart';
import 'user_form_widget.dart';
import 'loading_dialog_widget.dart';

/// Main User Add Body widget - now much cleaner and focused
class Useraddbody extends StatefulWidget {
  const Useraddbody({super.key});

  @override
  State<Useraddbody> createState() => _UseraddbodyState();
}

class _UseraddbodyState extends State<Useraddbody> {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();

  // State variables
  bool _isLoading = false;
  Map<String, dynamic> _userStats = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  /// Initialize data and load user statistics
  Future<void> _initializeData() async {
    setState(() => _isLoading = true);

    try {
      // Load user stats
      Map<String, dynamic> stats = await UserDataService.getUserStats();

      // Load last user data for editing (optional)
      Map<String, String>? lastUser = await UserDataService.loadLastUserData();

      setState(() {
        _userStats = stats;
        _isLoading = false;
      });

      // Optionally populate form with last user data
      if (lastUser != null && mounted) {
        UserDataService.populateControllers(
          userData: lastUser,
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
          ageController: _ageController,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'حدث خطأ في تحميل البيانات');
      }
    }
  }

  /// Handle form submission
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create user data map
      Map<String, String> userData = UserDataService.createUserDataMap(
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        addressController: _addressController,
        ageController: _ageController,
      );

      // Additional validation
      String? validationError = UserDataService.validateUserData(
        name: userData['name']!,
        email: userData['email']!,
        phone: userData['phone']!,
        address: userData['address']!,
        age: userData['age']!,
      );

      if (validationError != null) {
        SnackBarUtils.showError(context, validationError);
        return;
      }

      // Show confirmation dialog
      bool confirmed = await ConfirmationDialog.showSaveConfirmation(
        context,
        userData: userData,
      );

      if (!confirmed) return;

      // Show loading
      LoadingDialog.show(context, message: 'جاري حفظ البيانات...');

      // Save data
      String userId = await UserDataService.saveUserData(
        name: userData['name']!,
        email: userData['email']!,
        phone: userData['phone']!,
        address: userData['address']!,
        age: userData['age']!,
      );

      // Hide loading
      if (mounted) LoadingDialog.hide(context);

      // Show success message
      if (mounted) {
        SnackBarUtils.showSuccess(context, 'تم حفظ البيانات بنجاح');

        // Clear form after successful save
        UserDataService.clearControllers(
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
          ageController: _ageController,
        );

        // Navigate to fingerprint screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Savefingerview(),
          ),
        );
      }
    } catch (e) {
      // Hide loading if still showing
      if (mounted) {
        LoadingDialog.hide(context);
        SnackBarUtils.showError(context, 'حدث خطأ في حفظ البيانات');
      }
      debugPrint('Error in _handleSubmit: $e');
    }
  }

  /// Clear form data
  void _clearForm() {
    UserDataService.clearControllers(
      nameController: _nameController,
      emailController: _emailController,
      phoneController: _phoneController,
      addressController: _addressController,
      ageController: _ageController,
    );

    SnackBarUtils.showInfo(context, 'تم مسح النموذج');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري التحميل...'),
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (_userStats['hasUsers'] == true) _buildUserStatsCard(),

            const SizedBox(height: 16),

            UserFormWidget(
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
              ageController: _ageController,
              showSecurityInfo: true,
            ),

            const SizedBox(height: 30),

            // Submit button
            CustomButton(
              text: "تسجيل و حفظ البصمة",
              textColor: Colors.white,
              onTap: _handleSubmit,
            ),

            const SizedBox(height: 15),

            // Additional actions
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Build user statistics card
  // Widget _buildUserStatsCard() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.blue.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.blue.withOpacity(0.3)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Icon(Icons.people, color: Colors.blue, size: 20),
  //             const SizedBox(width: 8),
  //             Text(
  //               'إحصائيات المستخدمين',
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text('عدد المستخدمين: ${_userStats['totalUsers'] ?? 0}'),
  //         Text('آخر مستخدم: ${_userStats['lastUserName'] ?? 'لا يوجد'}'),
  //       ],
  //     ),
  //   );
  // }

  /// Build action buttons row
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Clear form button
        TextButton.icon(
          onPressed: _clearForm,
          icon: const Icon(Icons.clear_all, size: 16),
          label: const Text('مسح النموذج'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
        ),

        // View users button
        // TextButton.icon(
        //   onPressed: () {
        //     // You can implement a user list view here
        //     SnackBarUtils.showInfo(context, 'عرض المستخدمين - قريباً');
        //   },
        //   icon: const Icon(Icons.list, size: 16),
        //   label: const Text('عرض المستخدمين'),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.blue[600],
        //   ),
        // ),
      ],
    );
  }
}
