import 'package:flutter/material.dart';
import 'route_generator.dart';
import 'app_routes.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;
  static BuildContext get context => navigatorKey.currentContext!;

  // Basic navigation methods
  static Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return navigator.pushReplacementNamed<T, void>(routeName,
        arguments: arguments);
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    navigator.pop<T>(result);
  }

  static bool canPop() {
    return navigator.canPop();
  }

  static void popUntil(String routeName) {
    navigator.popUntil((route) => route.settings.name == routeName);
  }

  // App-specific navigation methods
  static Future<void> goToUserData() async {
    await pushNamed(AppRoutes.userData);
  }

  static Future<void> goToSaveFingerprint() async {
    await pushNamed(AppRoutes.saveFingerprint);
  }

  static Future<void> goToChooseBank({
    required bool firsttime,
    required String amount,
  }) async {
    await pushNamed(
      AppRoutes.chooseBank,
      arguments: {
        'firsttime': firsttime,
        'amount': amount,
      },
    );
  }

  static Future<void> goToPayment() async {
    await pushNamed(AppRoutes.payment);
  }

  static Future<void> goToHome({
    required String selectedBank,
    required String amount,
    required String customerName,
  }) async {
    await pushNamed(
      AppRoutes.home,
      arguments: {
        'selectedBank': selectedBank,
        'amount': amount,
        'customerName': customerName,
      },
    );
  }

  static Future<void> goToFingerprint() async {
    await pushNamed(AppRoutes.fingerprint);
  }

  // Replace current route
  static Future<void> replaceWithUserData() async {
    await pushReplacementNamed(AppRoutes.userData);
  }

  static Future<void> replaceWithSaveFingerprint() async {
    await pushReplacementNamed(AppRoutes.saveFingerprint);
  }

  static Future<void> replaceWithChooseBank({
    required bool firsttime,
    required String amount,
  }) async {
    await pushReplacementNamed(
      AppRoutes.chooseBank,
      arguments: {
        'firsttime': firsttime,
        'amount': amount,
      },
    );
  }

  static Future<void> replaceWithPayment() async {
    await pushReplacementNamed(AppRoutes.payment);
  }

  static Future<void> replaceWithHome({
    required String selectedBank,
    required String amount,
    required String customerName,
  }) async {
    await pushReplacementNamed(
      AppRoutes.home,
      arguments: {
        'selectedBank': selectedBank,
        'amount': amount,
        'customerName': customerName,
      },
    );
  }

  // Clear stack and navigate
  static Future<void> clearStackAndGoTo(String routeName,
      {Object? arguments}) async {
    await pushNamedAndRemoveUntil(
      routeName,
      arguments: arguments,
      predicate: (route) => false,
    );
  }

  static Future<void> clearStackAndGoToUserData() async {
    await clearStackAndGoTo(AppRoutes.userData);
  }

  static Future<void> clearStackAndGoToHome({
    required String selectedBank,
    required String amount,
    required String customerName,
  }) async {
    await clearStackAndGoTo(
      AppRoutes.home,
      arguments: {
        'selectedBank': selectedBank,
        'amount': amount,
        'customerName': customerName,
      },
    );
  }

  // Utility methods
  static String getCurrentRoute() {
    String currentRoute = '';
    navigator.popUntil((route) {
      currentRoute = route.settings.name ?? '';
      return true;
    });
    return currentRoute;
  }

  static bool isCurrentRoute(String routeName) {
    return getCurrentRoute() == routeName;
  }

  static void goBack() {
    if (canPop()) {
      pop();
    }
  }
}
