import 'package:flutter/material.dart';

abstract class AppTextStyle {
  // Simple typography - only what we need
  static TextStyle title = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    fontFamily: 'Cairo',
  );

  static TextStyle body = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Cairo',
  );

  static TextStyle small = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: 'Cairo',
  );

  static TextStyle button = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Cairo',
  );

  // Legacy styles for backward compatibility
  static TextStyle regular15 = small;
  static TextStyle regular20 = body;
  static TextStyle regular25 = title;
  static TextStyle medium515 = small;
  static TextStyle medium520 = body;
  static TextStyle medium625 = title;
  static TextStyle bold20 = title;
  static TextStyle bold25 = title;
  static TextStyle bold30 = title;
  static TextStyle bold50 = title;
}

abstract class AppColors {
  // Only 3 essential colors
  static const Color primary = Color.fromARGB(255, 21, 72, 114); // Blue
  static const Color secondary = Color(0xFF4CAF50); // Green
  static const Color accent = Color(0xFFFF9800); // Orange

  // Simple neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF212121);
  static const Color gray = Color(0xFF757575);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
}

abstract class AppSpacing {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 40.0;
}

abstract class AppBorders {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
}
