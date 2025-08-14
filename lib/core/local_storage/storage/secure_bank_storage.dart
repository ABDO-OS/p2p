// core/local_storage/storage/secure_bank_storage.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'secure_storage_helper.dart';

class SecureBankStorage {
  static const String _selectedBankKey = 'selected_bank';
  static const String _selectedBanksKey = 'selected_banks_list';
  static const String _lastSelectionKey = 'last_bank_selection';

  // Legacy method for backward compatibility
  static Future<void> saveSelectedBank(String bankName) async {
    await SecureStorageHelper.storage
        .write(key: _selectedBankKey, value: bankName);
    debugPrint('Bank saved: $bankName');
  }

  // Legacy method for backward compatibility
  static Future<String?> getSelectedBank() async {
    return await SecureStorageHelper.storage.read(key: _selectedBankKey);
  }

  /// Save multiple selected banks
  static Future<void> saveSelectedBanks(List<String> bankNames) async {
    try {
      final banksJson = jsonEncode(bankNames);
      await SecureStorageHelper.storage.write(
        key: _selectedBanksKey,
        value: banksJson,
      );
      debugPrint('Multiple banks saved: $bankNames');
    } catch (e) {
      debugPrint('Error saving multiple banks: $e');
    }
  }

  /// Get all selected banks
  static Future<List<String>> getSelectedBanks() async {
    try {
      final banksJson =
          await SecureStorageHelper.storage.read(key: _selectedBanksKey);
      if (banksJson == null || banksJson.isEmpty) {
        return [];
      }
      final List<dynamic> banksList = jsonDecode(banksJson);
      return banksList.map((bank) => bank.toString()).toList();
    } catch (e) {
      debugPrint('Error getting multiple banks: $e');
      return [];
    }
  }

  /// Save the last bank selection (for single bank operations)
  static Future<void> saveLastBankSelection(String bankName) async {
    try {
      await SecureStorageHelper.storage.write(
        key: _lastSelectionKey,
        value: bankName,
      );
      debugPrint('Last bank selection saved: $bankName');
    } catch (e) {
      debugPrint('Error saving last bank selection: $e');
    }
  }

  /// Get the last bank selection
  static Future<String?> getLastBankSelection() async {
    try {
      return await SecureStorageHelper.storage.read(key: _lastSelectionKey);
    } catch (e) {
      debugPrint('Error getting last bank selection: $e');
      return null;
    }
  }

  /// Clear all selected banks
  static Future<void> clearSelectedBanks() async {
    try {
      await SecureStorageHelper.storage.delete(key: _selectedBanksKey);
      await SecureStorageHelper.storage.delete(key: _lastSelectionKey);
      debugPrint('All bank selections cleared');
    } catch (e) {
      debugPrint('Error clearing bank selections: $e');
    }
  }
}
