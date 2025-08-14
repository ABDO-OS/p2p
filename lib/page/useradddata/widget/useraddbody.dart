import 'package:fingerprint_auth_example/page/useradddata/logic/user_add_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/customebottom.dart';
import 'user_form_widget.dart';
import 'user_action_buttons.dart';

class Useraddbody extends StatefulWidget {
  const Useraddbody({super.key});

  @override
  State<Useraddbody> createState() => _UseraddbodyState();
}

class _UseraddbodyState extends State<Useraddbody> {
  final _controller = UserAddController();
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWithTimeout();
  }

  Future<void> _initializeWithTimeout() async {
    try {
      // Add a shorter timeout to prevent infinite loading
      await Future.any([
        _controller.initializeData(context),
        Future.delayed(const Duration(seconds: 2)).then((_) {
          print('Useraddbody: Initialization timeout, continuing anyway...');
          // Don't throw error, just continue with empty form
        }),
      ]);
    } catch (e) {
      print('Useraddbody: Initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }

    // Ensure we always show the form after a reasonable time
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        print('Useraddbody: Force refresh after timeout');
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في التحميل',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = '';
                    });
                    _initializeWithTimeout();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        // Show loading only for a short time, then show the form
        if (_controller.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري التحميل...'),
                SizedBox(height: 8),
                Text('سيتم عرض النموذج قريباً', style: TextStyle(fontSize: 12)),
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
                const SizedBox(height: 16),
                UserFormWidget(
                  formKey: _controller.formKey,
                  nameController: _controller.nameController,
                  emailController: _controller.emailController,
                  phoneController: _controller.phoneController,
                  addressController: _controller.addressController,
                  ageController: _controller.ageController,
                  showSecurityInfo: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "تسجيل و حفظ البصمة",
                  textColor: Colors.white,
                  onTap: () => _controller.handleSubmit(context),
                ),
                const SizedBox(height: 15),
                UserActionButtons(controller: _controller),
              ],
            ),
          ),
        );
      },
    );
  }
}
