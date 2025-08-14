import 'package:flutter/material.dart';
import 'navigation_service.dart';

abstract class BaseRoute extends StatefulWidget {
  const BaseRoute({Key? key}) : super(key: key);
}

abstract class BaseRouteState<T extends BaseRoute> extends State<T> {
  bool _isLoading = false;
  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  bool get isDisposed => _isDisposed;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  void dispose() {
    _isDisposed = true;
    onDispose();
    super.dispose();
  }

  // Override these methods in subclasses
  void onInit() {}
  void onDispose() {}

  // Loading state management
  void setLoading(bool loading) {
    if (!_isDisposed && mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  void showLoading() => setLoading(true);
  void hideLoading() => setLoading(false);

  // Navigation helpers
  Future<void> navigateTo(String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (!_isDisposed && mounted) {
      await NavigationService.pushNamed(routeName, arguments: arguments);
    }
  }

  Future<void> navigateToReplace(String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (!_isDisposed && mounted) {
      await NavigationService.pushReplacementNamed(routeName,
          arguments: arguments);
    }
  }

  Future<void> navigateToHome({
    required String selectedBank,
    required String amount,
    required String customerName,
  }) async {
    if (!_isDisposed && mounted) {
      await NavigationService.goToHome(
        selectedBank: selectedBank,
        amount: amount,
        customerName: customerName,
      );
    }
  }

  Future<void> navigateToChooseBank({
    required bool firsttime,
    required String amount,
  }) async {
    if (!_isDisposed && mounted) {
      await NavigationService.goToChooseBank(
        firsttime: firsttime,
        amount: amount,
      );
    }
  }

  Future<void> navigateToPayment() async {
    if (!_isDisposed && mounted) {
      await NavigationService.goToPayment();
    }
  }

  Future<void> navigateToSaveFingerprint() async {
    if (!_isDisposed && mounted) {
      await NavigationService.goToSaveFingerprint();
    }
  }

  Future<void> navigateToUserData() async {
    if (!_isDisposed && mounted) {
      await NavigationService.goToUserData();
    }
  }

  // Go back
  void goBack() {
    if (!_isDisposed && mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Show snackbar
  void showSnackBar(String message, {Color? backgroundColor}) {
    if (!_isDisposed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  void showWarningSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.orange);
  }

  void showInfoSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.blue);
  }

  // Build method that includes loading state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري التحميل...'),
                ],
              ),
            )
          : buildBody(context),
    );
  }

  // Override this method in subclasses
  Widget buildBody(BuildContext context);
}
