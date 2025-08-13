// core/services/user_data/user_data_saver.dart
import 'package:flutter/foundation.dart';
import '../storage/secure_user_storage.dart';
import 'user_data_validator.dart';

class UserDataSaver {
  /// Save a new user
  static Future<String> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) async {
    try {
      String? validationError = UserDataValidator.validateUserData(
        name: name,
        email: email,
        phone: phone,
        address: address,
        age: age,
      );
      if (validationError != null) throw Exception(validationError);

      String userId = await SecureUserStorage.addUser(
        name: name,
        email: email,
        phone: phone,
        address: address,
        age: age,
      );
      debugPrint('User saved with ID: $userId');
      return userId;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  /// Update an existing user
  static Future<bool> updateUser(
      String userId, Map<String, String> newData) async {
    try {
      String? validationError = UserDataValidator.validateUserData(
        name: newData['name'] ?? '',
        email: newData['email'] ?? '',
        phone: newData['phone'] ?? '',
        address: newData['address'] ?? '',
        age: newData['age'] ?? '',
      );
      if (validationError != null) return false;

      return await SecureUserStorage.updateUser(userId, newData);
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  /// Delete a user
  static Future<bool> deleteUser(String userId) async {
    try {
      return await SecureUserStorage.deleteUser(userId);
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }
}
