// core/local_storage/storage/secure_bank_storage.dart
import 'package:flutter/foundation.dart';
import 'secure_storage_helper.dart';

class SecureBankStorage {
  static const String _selectedBankKey = 'selected_bank';

  static Future<void> saveSelectedBank(String bankName) async {
    await SecureStorageHelper.storage
        .write(key: _selectedBankKey, value: bankName);
    debugPrint('Bank saved: $bankName');
  }

  static Future<String?> getSelectedBank() async {
    return await SecureStorageHelper.storage.read(key: _selectedBankKey);
  }
}
