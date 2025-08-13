import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      print('Can check biometrics: $canCheck');
      return canCheck;
    } on PlatformException catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      print('Available biometrics: $biometrics');
      return biometrics;
    } on PlatformException catch (e) {
      print('Error getting biometrics: $e');
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    print('Starting authentication...');

    final isAvailable = await hasBiometrics();
    if (!isAvailable) {
      print('Biometrics not available.');
      return false;
    }

    final biometrics = await getBiometrics();
    if (biometrics.isEmpty) {
      print('No biometrics enrolled on this device.');
      return false;
    }

    try {
      final result = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      print('Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}
