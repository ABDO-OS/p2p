// core/services/user_data/user_data_stats.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../storage/secure_user_storage.dart';

class UserDataStats {
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      int totalUsers = await SecureUserStorage.getUserCount();
      Map<String, String>? lastUser = await SecureUserStorage.getLastUser();
      return {
        'totalUsers': totalUsers,
        'hasUsers': totalUsers > 0,
        'lastUser': lastUser,
        'lastUserName': lastUser?['name'] ?? 'لا يوجد',
      };
    } catch (e) {
      return {
        'totalUsers': 0,
        'hasUsers': false,
        'lastUser': null,
        'lastUserName': 'خطأ',
      };
    }
  }

  static Future<Map<String, dynamic>> getAdvancedUserStats() async {
    try {
      int totalUsers = await SecureUserStorage.getUserCount();
      List<Map<String, String>> recentUsers =
          await SecureUserStorage.getRecentUsers(7);
      Map<String, String>? lastUser = await SecureUserStorage.getLastUser();

      return {
        'totalUsers': totalUsers,
        'recentUsers': recentUsers.length,
        'growthThisWeek': recentUsers.length,
        'lastUserName': lastUser?['name'] ?? 'لا يوجد',
      };
    } catch (_) {
      return {
        'totalUsers': 0,
        'recentUsers': 0,
        'growthThisWeek': 0,
        'lastUserName': 'خطأ',
      };
    }
  }

  static Future<String?> exportUsers({
    bool prettyFormat = false,
  }) async {
    try {
      String? exportData = await SecureUserStorage.exportUsersData();
      if (exportData == null) return null;

      if (prettyFormat) {
        return JsonEncoder.withIndent('  ').convert(jsonDecode(exportData));
      }
      return exportData;
    } catch (e) {
      debugPrint('Error exporting users: $e');
      return null;
    }
  }
}
