import 'package:flutter/foundation.dart';
import '../storage/secure_bank_storage.dart';

class SelectedBanksService {
  static const String _selectedBanksKey = 'selected_banks_list';
  static const String _lastSelectionKey = 'last_bank_selection';

  /// Save multiple selected banks
  static Future<void> saveSelectedBanks(List<String> bankNames) async {
    try {
      await SecureBankStorage.saveSelectedBanks(bankNames);
      debugPrint('Selected banks saved: $bankNames');
    } catch (e) {
      debugPrint('Error saving selected banks: $e');
    }
  }

  /// Get all selected banks
  static Future<List<String>> getSelectedBanks() async {
    try {
      final banks = await SecureBankStorage.getSelectedBanks();
      debugPrint('Retrieved selected banks: $banks');
      return banks;
    } catch (e) {
      debugPrint('Error getting selected banks: $e');
      return [];
    }
  }

  /// Save the last bank selection (for single bank operations)
  static Future<void> saveLastBankSelection(String bankName) async {
    try {
      await SecureBankStorage.saveLastBankSelection(bankName);
      debugPrint('Last bank selection saved: $bankName');
    } catch (e) {
      debugPrint('Error saving last bank selection: $e');
    }
  }

  /// Get the last bank selection
  static Future<String?> getLastBankSelection() async {
    try {
      final bank = await SecureBankStorage.getLastBankSelection();
      debugPrint('Retrieved last bank selection: $bank');
      return bank;
    } catch (e) {
      debugPrint('Error getting last bank selection: $e');
      return null;
    }
  }

  /// Check if user has selected banks
  static Future<bool> hasSelectedBanks() async {
    final banks = await getSelectedBanks();
    return banks.isNotEmpty;
  }

  /// Clear all selected banks
  static Future<void> clearSelectedBanks() async {
    try {
      await SecureBankStorage.clearSelectedBanks();
      debugPrint('Selected banks cleared');
    } catch (e) {
      debugPrint('Error clearing selected banks: $e');
    }
  }

  /// Add a single bank to selection
  static Future<void> addBankToSelection(String bankName) async {
    try {
      final currentBanks = await getSelectedBanks();
      if (!currentBanks.contains(bankName)) {
        currentBanks.add(bankName);
        await saveSelectedBanks(currentBanks);
        debugPrint('Bank added to selection: $bankName');
      }
    } catch (e) {
      debugPrint('Error adding bank to selection: $e');
    }
  }

  /// Remove a bank from selection
  static Future<void> removeBankFromSelection(String bankName) async {
    try {
      final currentBanks = await getSelectedBanks();
      currentBanks.remove(bankName);
      await saveSelectedBanks(currentBanks);
      debugPrint('Bank removed from selection: $bankName');
    } catch (e) {
      debugPrint('Error removing bank from selection: $e');
    }
  }
}
