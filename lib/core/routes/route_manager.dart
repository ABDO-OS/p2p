import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'navigation_service.dart';

class RouteManager {
  static final RouteManager _instance = RouteManager._internal();
  factory RouteManager() => _instance;
  RouteManager._internal();

  // Route history tracking
  final List<String> _routeHistory = [];
  final Map<String, dynamic> _routeData = {};

  // Getters
  List<String> get routeHistory => List.unmodifiable(_routeHistory);
  String? get currentRoute =>
      _routeHistory.isNotEmpty ? _routeHistory.last : null;
  Map<String, dynamic> get routeData => Map.unmodifiable(_routeData);

  // Route management
  void addRoute(String routeName, {Map<String, dynamic>? data}) {
    _routeHistory.add(routeName);
    if (data != null) {
      _routeData[routeName] = data;
    }
    print('Route added: $routeName, History: $_routeHistory');
  }

  void removeRoute(String routeName) {
    _routeHistory.remove(routeName);
    _routeData.remove(routeName);
    print('Route removed: $routeName, History: $_routeHistory');
  }

  void clearHistory() {
    _routeHistory.clear();
    _routeData.clear();
    print('Route history cleared');
  }

  bool hasRoute(String routeName) {
    return _routeHistory.contains(routeName);
  }

  // Navigation with history tracking
  Future<void> navigateTo(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
    bool replace = false,
    bool trackHistory = true,
  }) async {
    if (trackHistory) {
      addRoute(routeName, data: arguments);
    }

    if (replace) {
      await NavigationService.pushReplacementNamed(routeName,
          arguments: arguments);
    } else {
      await NavigationService.pushNamed(routeName, arguments: arguments);
    }
  }

  Future<void> navigateToUserData(BuildContext context) async {
    await navigateTo(context, AppRoutes.userData);
  }

  Future<void> navigateToSaveFingerprint(BuildContext context) async {
    await navigateTo(context, AppRoutes.saveFingerprint);
  }

  Future<void> navigateToChooseBank(
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

  Future<void> navigateToPayment(BuildContext context) async {
    await navigateTo(context, AppRoutes.payment);
  }

  Future<void> navigateToHome(
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

  Future<void> navigateToFingerprint(BuildContext context) async {
    await navigateTo(context, AppRoutes.fingerprint);
  }

  // Replace current route
  Future<void> replaceCurrentRoute(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    if (_routeHistory.isNotEmpty) {
      removeRoute(_routeHistory.last);
    }
    await navigateTo(context, routeName, arguments: arguments, replace: true);
  }

  // Pop and navigate
  Future<void> popAndNavigate(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    if (_routeHistory.isNotEmpty) {
      removeRoute(_routeHistory.last);
    }
    Navigator.of(context).pop();
    await navigateTo(context, routeName, arguments: arguments);
  }

  // Pop until specific route
  Future<void> popUntilRoute(
    BuildContext context,
    String routeName,
  ) async {
    final routesToRemove = <String>[];
    bool found = false;

    for (int i = _routeHistory.length - 1; i >= 0; i--) {
      if (_routeHistory[i] == routeName) {
        found = true;
        break;
      }
      routesToRemove.add(_routeHistory[i]);
    }

    if (found) {
      for (final route in routesToRemove) {
        removeRoute(route);
      }
      Navigator.of(context)
          .popUntil((route) => route.settings.name == routeName);
    }
  }

  // Clear stack and navigate
  Future<void> clearStackAndNavigate(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    clearHistory();
    await NavigationService.pushNamedAndRemoveUntil(
      routeName,
      arguments: arguments,
      predicate: (route) => false,
    );
  }

  // Get route data
  Map<String, dynamic>? getRouteData(String routeName) {
    return _routeData[routeName];
  }

  // Check if can go back
  bool canGoBack() {
    return _routeHistory.length > 1;
  }

  // Go back to previous route
  Future<void> goBack(BuildContext context) async {
    if (canGoBack()) {
      removeRoute(_routeHistory.last);
      Navigator.of(context).pop();
    }
  }

  // Get previous route
  String? getPreviousRoute() {
    if (_routeHistory.length > 1) {
      return _routeHistory[_routeHistory.length - 2];
    }
    return null;
  }

  // Print route information for debugging
  void printRouteInfo() {
    print('=== Route Manager Info ===');
    print('Current Route: $currentRoute');
    print('Route History: $_routeHistory');
    print('Route Data: $_routeData');
    print('Can Go Back: ${canGoBack()}');
    print('Previous Route: ${getPreviousRoute()}');
    print('=======================');
  }
}
