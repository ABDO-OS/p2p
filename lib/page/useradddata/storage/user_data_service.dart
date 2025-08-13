import 'dart:convert';

import 'package:fingerprint_auth_example/page/useradddata/storage/helper.dart';
import 'package:flutter/material.dart';

// Import your secure storage helper - update the path as needed
/// Service class to handle user data operations
class UserDataService {
  /// Load the most recent user data for editing
  static Future<Map<String, String>?> loadLastUserData() async {
    try {
      List<Map<String, String>> users = await SecureUserStorage.getAllUsers();
      if (users.isNotEmpty) {
        return users.last; // Return the most recent user
      }
      return null;
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return null;
    }
  }

  /// Save new user data securely
  static Future<String> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) async {
    try {
      String userId = await SecureUserStorage.addUser(
        name: name,
        email: email,
        phone: phone,
        address: address,
        age: age,
      );

      debugPrint('User data saved successfully with ID: $userId');
      return userId;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Validate user data before saving
  static String? validateUserData({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) {
    // Check for empty fields
    if (name.trim().isEmpty) return "الاسم مطلوب";
    if (email.trim().isEmpty) return "الايميل مطلوب";
    if (phone.trim().isEmpty) return "الرقم مطلوب";
    if (address.trim().isEmpty) return "العنوان مطلوب";
    if (age.trim().isEmpty) return "العمر مطلوب";

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim())) {
      return "ادخل ايميل صحيح";
    }

    // Validate age
    final ageInt = int.tryParse(age.trim());
    if (ageInt == null) return "ادخل رقماً صحيحاً للعمر";
    if (ageInt < 1 || ageInt > 150) return "ادخل عمراً صحيحاً";

    // Validate phone (basic validation)
    if (phone.trim().length < 8) return "رقم الهاتف قصير جداً";

    // Validate name length
    if (name.trim().length < 2) return "الاسم قصير جداً";

    return null; // All validations passed
  }

  /// Get user statistics
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
      debugPrint('Error getting user stats: $e');
      return {
        'totalUsers': 0,
        'hasUsers': false,
        'lastUser': null,
        'lastUserName': 'خطأ في التحميل',
      };
    }
  }

  /// Get advanced user statistics
  static Future<Map<String, dynamic>> getAdvancedUserStats() async {
    try {
      int totalUsers = await SecureUserStorage.getUserCount();
      List<Map<String, String>> recentUsers =
          await SecureUserStorage.getRecentUsers(7); // Last 7 days
      Map<String, String>? lastUser = await SecureUserStorage.getLastUser();

      return {
        'totalUsers': totalUsers,
        'recentUsers': recentUsers.length,
        'hasUsers': totalUsers > 0,
        'lastUser': lastUser,
        'lastUserName': lastUser?['name'] ?? 'لا يوجد',
        'growthThisWeek': recentUsers.length,
      };
    } catch (e) {
      debugPrint('Error getting advanced user stats: $e');
      return {
        'totalUsers': 0,
        'recentUsers': 0,
        'hasUsers': false,
        'lastUser': null,
        'lastUserName': 'خطأ في التحميل',
        'growthThisWeek': 0,
      };
    }
  }

  /// Clear form controllers
  static void clearControllers({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    ageController.clear();
  }

  /// Populate form controllers with user data
  static void populateControllers({
    required Map<String, String> userData,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    nameController.text = userData['name'] ?? '';
    emailController.text = userData['email'] ?? '';
    phoneController.text = userData['phone'] ?? '';
    addressController.text = userData['address'] ?? '';
    ageController.text = userData['age'] ?? '';
  }

  /// Create user data map from controllers
  static Map<String, String> createUserDataMap({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController ageController,
  }) {
    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'age': ageController.text.trim(),
    };
  }

  /// Search users with advanced filtering
  static Future<List<Map<String, String>>> searchUsers({
    required String query,
    String? filterBy, // 'name', 'email', 'phone', etc.
  }) async {
    try {
      if (query.trim().isEmpty) return [];

      List<Map<String, String>> users = await SecureUserStorage.getAllUsers();
      String lowerQuery = query.toLowerCase().trim();

      return users.where((user) {
        if (filterBy != null && filterBy.isNotEmpty) {
          // Search in specific field only
          String fieldValue = (user[filterBy] ?? '').toLowerCase();
          return fieldValue.contains(lowerQuery);
        } else {
          // Search in all fields
          String name = (user['name'] ?? '').toLowerCase();
          String email = (user['email'] ?? '').toLowerCase();
          String phone = (user['phone'] ?? '').toLowerCase();
          String address = (user['address'] ?? '').toLowerCase();

          return name.contains(lowerQuery) ||
              email.contains(lowerQuery) ||
              phone.contains(lowerQuery) ||
              address.contains(lowerQuery);
        }
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Export users data with formatting options
  static Future<String?> exportUsers({
    bool includeTimestamps = true,
    bool prettyFormat = false,
  }) async {
    try {
      String? exportData = await SecureUserStorage.exportUsersData();
      if (exportData == null) return null;

      if (prettyFormat) {
        // Pretty print JSON
        Map<String, dynamic> data = jsonDecode(exportData);
        return JsonEncoder.withIndent('  ').convert(data);
      }

      return exportData;
    } catch (e) {
      debugPrint('Error exporting users: $e');
      return null;
    }
  }

  /// Import users data with validation
  static Future<bool> importUsers(String jsonData) async {
    try {
      // Validate JSON format first
      Map<String, dynamic> data = jsonDecode(jsonData);

      if (!data.containsKey('users')) {
        debugPrint('Invalid import format: missing users key');
        return false;
      }

      List<dynamic> users = data['users'];
      if (users.isEmpty) {
        debugPrint('No users to import');
        return false;
      }

      // Validate user data structure
      for (var user in users) {
        if (user is! Map<String, dynamic>) {
          debugPrint('Invalid user data format');
          return false;
        }

        Map<String, dynamic> userData = user;
        if (!userData.containsKey('name') ||
            !userData.containsKey('email') ||
            !userData.containsKey('phone')) {
          debugPrint('Missing required user fields');
          return false;
        }
      }

      // Import the data
      bool success = await SecureUserStorage.importUsersData(jsonData);
      if (success) {
        debugPrint('Successfully imported ${users.length} users');
      }

      return success;
    } catch (e) {
      debugPrint('Error importing users: $e');
      return false;
    }
  }

  /// Delete user with confirmation
  static Future<bool> deleteUser(String userId) async {
    try {
      bool success = await SecureUserStorage.deleteUser(userId);
      if (success) {
        debugPrint('User deleted successfully: $userId');
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  /// Update existing user
  static Future<bool> updateUser(
      String userId, Map<String, String> newData) async {
    try {
      // Validate the new data first
      String? validationError = validateUserData(
        name: newData['name'] ?? '',
        email: newData['email'] ?? '',
        phone: newData['phone'] ?? '',
        address: newData['address'] ?? '',
        age: newData['age'] ?? '',
      );

      if (validationError != null) {
        debugPrint('Validation error: $validationError');
        return false;
      }

      bool success = await SecureUserStorage.updateUser(userId, newData);
      if (success) {
        debugPrint('User updated successfully: $userId');
      }
      return success;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }
}
