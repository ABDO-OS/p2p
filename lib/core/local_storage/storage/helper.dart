import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A secure storage helper class to manage user data
/// This class provides encrypted storage for sensitive user information
class SecureUserStorage {
  // Configure secure storage with maximum security options
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainItemAccessibility.first_unlock_this_device,
      accountName: 'SecureUserData',
    ),
  );

  // Storage keys
  static const String _usersListKey = 'secure_users_list';
  static const String _currentUserKey = 'current_user';
  static const String _selectedBankKey = 'selected_bank';

  /// Add a new user to secure storage
  static Future<String> addUser({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) async {
    try {
      final userId = DateTime.now().millisecondsSinceEpoch.toString();

      final userData = {
        'id': userId,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
        'age': age.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };

      // Get existing users
      List<Map<String, String>> users = await getAllUsers();

      // Add new user
      users.add(userData);

      // Keep only the last 100 users to prevent excessive storage
      if (users.length > 100) {
        users = users.sublist(users.length - 100);
      }

      // Save to secure storage
      await _secureStorage.write(
        key: _usersListKey,
        value: jsonEncode(users),
      );

      debugPrint('User added successfully. Total users: ${users.length}');
      return userId;
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  /// Get all saved users
  static Future<List<Map<String, String>>> getAllUsers() async {
    try {
      String? usersJson = await _secureStorage.read(key: _usersListKey);
      if (usersJson == null || usersJson.isEmpty) return [];

      List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.map((user) => Map<String, String>.from(user)).toList();
    } catch (e) {
      debugPrint('Error reading users: $e');
      return [];
    }
  }

  /// Get user by ID
  static Future<Map<String, String>?> getUserById(String userId) async {
    try {
      List<Map<String, String>> users = await getAllUsers();
      for (var user in users) {
        if (user['id'] == userId) {
          return user;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      return null;
    }
  }

  /// Get the most recent user
  static Future<Map<String, String>?> getLastUser() async {
    try {
      List<Map<String, String>> users = await getAllUsers();
      if (users.isEmpty) return null;
      return users.last;
    } catch (e) {
      debugPrint('Error getting last user: $e');
      return null;
    }
  }

  /// Update user data
  static Future<bool> updateUser(
      String userId, Map<String, String> newData) async {
    try {
      List<Map<String, String>> users = await getAllUsers();

      for (int i = 0; i < users.length; i++) {
        if (users[i]['id'] == userId) {
          // Keep original ID and created_at
          newData['id'] = userId;
          newData['created_at'] =
              users[i]['created_at'] ?? DateTime.now().toIso8601String();
          newData['updated_at'] = DateTime.now().toIso8601String();

          users[i] = newData;

          await _secureStorage.write(
            key: _usersListKey,
            value: jsonEncode(users),
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  /// Delete user by ID
  static Future<bool> deleteUser(String userId) async {
    try {
      List<Map<String, String>> users = await getAllUsers();
      int originalLength = users.length;

      users.removeWhere((user) => user['id'] == userId);

      if (users.length < originalLength) {
        await _secureStorage.write(
          key: _usersListKey,
          value: jsonEncode(users),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  /// Set current active user
  static Future<void> setCurrentUser(String userId) async {
    try {
      await _secureStorage.write(key: _currentUserKey, value: userId);
    } catch (e) {
      debugPrint('Error setting current user: $e');
    }
  }

  /// Get current active user
  static Future<Map<String, String>?> getCurrentUser() async {
    try {
      String? currentUserId = await _secureStorage.read(key: _currentUserKey);
      if (currentUserId == null) return null;

      return await getUserById(currentUserId);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Save selected bank for current user
  static Future<void> saveSelectedBank(String bankName) async {
    try {
      await _secureStorage.write(key: _selectedBankKey, value: bankName);
    } catch (e) {
      debugPrint('Error saving selected bank: $e');
    }
  }

  /// Get selected bank
  static Future<String?> getSelectedBank() async {
    try {
      return await _secureStorage.read(key: _selectedBankKey);
    } catch (e) {
      debugPrint('Error getting selected bank: $e');
      return null;
    }
  }

  /// Get total number of users
  static Future<int> getUserCount() async {
    try {
      List<Map<String, String>> users = await getAllUsers();
      return users.length;
    } catch (e) {
      debugPrint('Error getting user count: $e');
      return 0;
    }
  }

  /// Search users by name or email
  static Future<List<Map<String, String>>> searchUsers(String query) async {
    try {
      if (query.trim().isEmpty) return [];

      List<Map<String, String>> users = await getAllUsers();
      String lowerQuery = query.toLowerCase().trim();

      return users.where((user) {
        String name = (user['name'] ?? '').toLowerCase();
        String email = (user['email'] ?? '').toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Clear all user data (for privacy/logout)
  static Future<void> clearAllData() async {
    try {
      await _secureStorage.deleteAll();
      debugPrint('All secure data cleared');
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }

  /// Clear only user list (keep other settings)
  static Future<void> clearAllUsers() async {
    try {
      await _secureStorage.delete(key: _usersListKey);
      await _secureStorage.delete(key: _currentUserKey);
      debugPrint('All users cleared');
    } catch (e) {
      debugPrint('Error clearing users: $e');
    }
  }

  /// Export user data (for backup purposes)
  static Future<String?> exportUsersData() async {
    try {
      List<Map<String, String>> users = await getAllUsers();
      if (users.isEmpty) return null;

      return jsonEncode({
        'users': users,
        'exported_at': DateTime.now().toIso8601String(),
        'total_users': users.length,
      });
    } catch (e) {
      debugPrint('Error exporting users data: $e');
      return null;
    }
  }

  /// Check if storage has any users
  static Future<bool> hasUsers() async {
    try {
      int count = await getUserCount();
      return count > 0;
    } catch (e) {
      debugPrint('Error checking if has users: $e');
      return false;
    }
  }

  /// Import user data (for restore purposes)
  static Future<bool> importUsersData(String jsonData) async {
    try {
      Map<String, dynamic> importData = jsonDecode(jsonData);
      List<dynamic> importedUsers = importData['users'] ?? [];

      if (importedUsers.isEmpty) return false;

      // Convert to proper format
      List<Map<String, String>> users =
          importedUsers.map((user) => Map<String, String>.from(user)).toList();

      // Save imported users
      await _secureStorage.write(
        key: _usersListKey,
        value: jsonEncode(users),
      );

      debugPrint('Successfully imported ${users.length} users');
      return true;
    } catch (e) {
      debugPrint('Error importing users data: $e');
      return false;
    }
  }

  /// Get users created in the last N days
  static Future<List<Map<String, String>>> getRecentUsers(int days) async {
    try {
      List<Map<String, String>> allUsers = await getAllUsers();
      DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));

      return allUsers.where((user) {
        String? createdAtStr = user['created_at'];
        if (createdAtStr == null) return false;

        try {
          DateTime createdAt = DateTime.parse(createdAtStr);
          return createdAt.isAfter(cutoffDate);
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {
      debugPrint('Error getting recent users: $e');
      return [];
    }
  }
}

mixin KeychainItemAccessibility {
  static get first_unlock_this_device => null;
}
