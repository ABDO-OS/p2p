import 'package:flutter/material.dart';
import '../splash/loading_dialog_widget.dart';
import '../../api/local_auth_api.dart';
import '../../page/useradddata/view/userview.dart';
import '../../page/Savefingerandbank/view/savefingerview.dart';
import '../../page/choosebanke/view/choosebankview.dart';
import '../../page/entermony/entermony.dart';
import '../../page/home/home_page.dart';
import '../../page/fingerprint_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
        return MaterialPageRoute(
          builder: (_) => const Userview(),
          settings: settings,
        );

      case AppRoutes.userData:
        return MaterialPageRoute(
          builder: (_) => const Userview(),
          settings: settings,
        );

      case AppRoutes.saveFingerprint:
        final args = settings.arguments as Map<String, dynamic>?;
        final customerName = args?['customerName'];

        return MaterialPageRoute(
          builder: (_) => Savefingerview(customerName: customerName),
          settings: settings,
        );

      case AppRoutes.chooseBank:
        final args = settings.arguments as Map<String, dynamic>?;
        final firsttime = args?['firsttime'] ?? false;
        final amount = args?['amount'] ?? '';
        final customerName = args?['customerName'];

        return MaterialPageRoute(
          builder: (_) => Choosebankview(
            firsttime: firsttime,
            amount: amount,
            customerName: customerName,
          ),
          settings: settings,
        );

      case AppRoutes.payment:
        final args = settings.arguments as Map<String, dynamic>?;
        final customerName = args?['customerName'];

        return MaterialPageRoute(
          builder: (_) => PaymentScreen(customerName: customerName),
          settings: settings,
        );

      case AppRoutes.home:
        final args = settings.arguments as Map<String, dynamic>?;
        final selectedBank = args?['selectedBank'] ?? '';
        final amount = args?['amount'] ?? '';
        final customerName = args?['customerName'] ?? '';

        return MaterialPageRoute(
          builder: (_) => HomePage(
            selectedBank: selectedBank,
            amount: amount,
            customerName: customerName,
          ),
          settings: settings,
        );

      case AppRoutes.fingerprint:
        return MaterialPageRoute(
          builder: (_) => FingerprintPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Userview(),
          settings: settings,
        );
    }
  }

  // Navigation helper methods
  static Future<void> navigateTo(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
    bool replace = false,
  }) async {
    if (replace) {
      Navigator.of(context)
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    }
  }

  static Future<void> navigateToUserData(BuildContext context) async {
    await navigateTo(context, AppRoutes.userData);
  }

  static Future<void> navigateToSaveFingerprint(BuildContext context) async {
    await navigateTo(context, AppRoutes.saveFingerprint);
  }

  static Future<void> navigateToChooseBank(
    BuildContext context, {
    required bool firsttime,
    required String amount,
  }) async {
    await navigateTo(
      context,
      AppRoutes.chooseBank,
      arguments: {
        'firsttime': firsttime,
        'amount': amount,
      },
    );
  }

  static Future<void> navigateToPayment(BuildContext context) async {
    await navigateTo(context, AppRoutes.payment);
  }

  static Future<void> navigateToHome(
    BuildContext context, {
    required String selectedBank,
    required String amount,
    required String customerName,
  }) async {
    await navigateTo(
      context,
      AppRoutes.home,
      arguments: {
        'selectedBank': selectedBank,
        'amount': amount,
        'customerName': customerName,
      },
    );
  }

  static Future<void> navigateToFingerprint(BuildContext context) async {
    await navigateTo(context, AppRoutes.fingerprint);
  }

  // Authentication-based navigation
  static Future<void> navigateWithFingerprint(
    BuildContext context,
    String targetRoute, {
    Map<String, dynamic>? arguments,
    bool replace = false,
    String? message,
  }) async {
    LoadingDialog.show(context, message: message ?? 'جاري التحقق من البصمة...');

    try {
      final isAuthenticated = await LocalAuthApi.authenticate();
      LoadingDialog.hide(context);

      if (isAuthenticated) {
        await navigateTo(context, targetRoute,
            arguments: arguments, replace: replace);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في التحقق من البصمة')),
        );
      }
    } catch (e) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  // Pop and navigate
  static Future<void> popAndNavigate(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    Navigator.of(context).pop();
    await navigateTo(context, routeName, arguments: arguments);
  }

  // Pop until and navigate
  static Future<void> popUntilAndNavigate(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    await navigateTo(context, routeName, arguments: arguments);
  }
}
