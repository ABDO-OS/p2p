// core/services/user_data/user_data_loader.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../storage/secure_user_storage.dart';

class UserDataLoader {
  /// Load the most recent user data
  static Future<Map<String, String>?> loadLastUserData() async {
    try {
      List<Map<String, String>> users = await SecureUserStorage.getAllUsers();
      return users.isNotEmpty ? users.last : null;
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return null;
    }
  }

  /// Search users with optional filtering
  static Future<List<Map<String, String>>> searchUsers({
    required String query,
    String? filterBy, // 'name', 'email', etc.
  }) async {
    try {
      if (query.trim().isEmpty) return [];
      List<Map<String, String>> users = await SecureUserStorage.getAllUsers();
      String lowerQuery = query.toLowerCase().trim();

      return users.where((user) {
        if (filterBy != null && filterBy.isNotEmpty) {
          String fieldValue = (user[filterBy] ?? '').toLowerCase();
          return fieldValue.contains(lowerQuery);
        }
        return user.values
            .any((value) => (value ?? '').toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Import users data
  static Future<bool> importUsers(String jsonData) async {
    try {
      Map<String, dynamic> data = jsonDecode(jsonData);
      if (!data.containsKey('users') || (data['users'] as List).isEmpty) {
        debugPrint('Invalid or empty user list');
        return false;
      }
      return await SecureUserStorage.importUsersData(jsonData);
    } catch (e) {
      debugPrint('Error importing users: $e');
      return false;
    }
  }
}
