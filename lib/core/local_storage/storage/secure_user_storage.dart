// core/local_storage/storage/secure_user_storage.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'secure_storage_helper.dart';

class SecureUserStorage {
  static const String _usersListKey = 'secure_users_list';
  static const String _currentUserKey = 'current_user';

  static Future<String> addUser({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) async {
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

    List<Map<String, String>> users = await getAllUsers();
    users.add(userData);

    await SecureStorageHelper.storage.write(
      key: _usersListKey,
      value: jsonEncode(users),
    );

    debugPrint('User added successfully. Total users: ${users.length}');
    return userId;
  }

  static Future<List<Map<String, String>>> getAllUsers() async {
    try {
      print('SecureUserStorage: Reading users from secure storage...');
      String? usersJson =
          await SecureStorageHelper.storage.read(key: _usersListKey);
      print('SecureUserStorage: Raw data from storage: $usersJson');

      if (usersJson == null || usersJson.isEmpty) {
        print('SecureUserStorage: No users data found, returning empty list');
        return [];
      }

      List<dynamic> usersList = jsonDecode(usersJson);
      print('SecureUserStorage: Parsed users list: $usersList');

      List<Map<String, String>> result =
          usersList.map((user) => Map<String, String>.from(user)).toList();
      print('SecureUserStorage: Returning ${result.length} users');
      return result;
    } catch (e) {
      print('SecureUserStorage: Error reading users: $e');
      return [];
    }
  }

  static Future<Map<String, String>?> getLastUser() async {
    try {
      print('SecureUserStorage: Getting last user...');
      List<Map<String, String>> users = await getAllUsers();
      if (users.isEmpty) {
        print('SecureUserStorage: No users found, returning null');
        return null;
      }

      Map<String, String> lastUser = users.last;
      print('SecureUserStorage: Last user: $lastUser');
      return lastUser;
    } catch (e) {
      print('SecureUserStorage: Error getting last user: $e');
      return null;
    }
  }

  static Future<int> getUserCount() async {
    try {
      print('SecureUserStorage: Getting user count...');
      List<Map<String, String>> users = await getAllUsers();
      print('SecureUserStorage: User count: ${users.length}');
      return users.length;
    } catch (e) {
      print('SecureUserStorage: Error getting user count: $e');
      return 0;
    }
  }

  static Future<bool> deleteUser(String userId) async {
    List<Map<String, String>> users = await getAllUsers();
    users.removeWhere((user) => user['id'] == userId);

    await SecureStorageHelper.storage.write(
      key: _usersListKey,
      value: jsonEncode(users),
    );
    return true;
  }

  static Future<bool> updateUser(
      String userId, Map<String, String> newData) async {
    List<Map<String, String>> users = await getAllUsers();
    for (int i = 0; i < users.length; i++) {
      if (users[i]['id'] == userId) {
        newData['id'] = userId;
        newData['created_at'] =
            users[i]['created_at'] ?? DateTime.now().toIso8601String();
        newData['updated_at'] = DateTime.now().toIso8601String();
        users[i] = newData;
      }
    }
    await SecureStorageHelper.storage.write(
      key: _usersListKey,
      value: jsonEncode(users),
    );
    return true;
  }

  static Future<String?> exportUsersData() async {
    List<Map<String, String>> users = await getAllUsers();
    if (users.isEmpty) return null;
    return jsonEncode({
      'users': users,
      'exported_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<bool> importUsersData(String jsonData) async {
    Map<String, dynamic> importData = jsonDecode(jsonData);
    List<dynamic> importedUsers = importData['users'] ?? [];
    if (importedUsers.isEmpty) return false;

    List<Map<String, String>> users =
        importedUsers.map((user) => Map<String, String>.from(user)).toList();

    await SecureStorageHelper.storage.write(
      key: _usersListKey,
      value: jsonEncode(users),
    );
    return true;
  }

  static Future<List<Map<String, String>>> getRecentUsers(int days) async {
    List<Map<String, String>> allUsers = await getAllUsers();
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));

    return allUsers.where((user) {
      String? createdAtStr = user['created_at'];
      if (createdAtStr == null) return false;
      try {
        DateTime createdAt = DateTime.parse(createdAtStr);
        return createdAt.isAfter(cutoffDate);
      } catch (_) {
        return false;
      }
    }).toList();
  }
}
