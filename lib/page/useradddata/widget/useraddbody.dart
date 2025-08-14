import 'package:fingerprint_auth_example/page/useradddata/logic/user_add_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/simple_button.dart';
import '../../../core/styles/appstyles.dart';
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
      await Future.any([
        _controller.initializeData(context),
        Future.delayed(const Duration(seconds: 2)).then((_) {
          print('Useraddbody: Initialization timeout, continuing anyway...');
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
    return Container(
      color: AppColors.lightGray,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_hasError) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppBorders.medium,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(height: AppSpacing.sm),
                    Icon(
                      Icons.error_outline_rounded,
                      size: 40,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'حدث خطأ في التحميل',
                      style: AppTextStyle.title.copyWith(
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.small.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SimpleButton(
                      text: 'إعادة المحاولة',
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _errorMessage = '';
                        });
                        _initializeWithTimeout();
                      },
                      icon: Icons.refresh_rounded,
                    ),
                  ],
                ),
              ),
            );
          }

          if (_controller.isLoading) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppBorders.medium,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'جاري التحميل...',
                      style: AppTextStyle.title.copyWith(
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'سيتم عرض النموذج قريباً',
                      style: AppTextStyle.small.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xs),

                  // User form widget
                  UserFormWidget(
                    formKey: _controller.formKey,
                    nameController: _controller.nameController,
                    emailController: _controller.emailController,
                    phoneController: _controller.phoneController,
                    addressController: _controller.addressController,
                    ageController: _controller.ageController,
                    showSecurityInfo: true,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // User action buttons
                  UserActionButtons(controller: _controller),

                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
