// core/local_storage/storage/secure_storage_helper.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Common secure storage instance used by all storage classes
class SecureStorageHelper {
  static final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accountName: 'SecureAppData',
    ),
  );
}
