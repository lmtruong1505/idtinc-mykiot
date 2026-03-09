import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  LocalAuthService._internal();

  static final LocalAuthService instance = LocalAuthService._internal();
  
  late final LocalAuthentication auth;
  late final List<BiometricType> availableBiometrics;

  Future<void> init() async {
    auth = LocalAuthentication();
    availableBiometrics = await auth.getAvailableBiometrics();
  }

  Future<BiometricType?> biometricAvailable() async {
    if (availableBiometrics.contains(BiometricType.face)) {
      return BiometricType.face;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return BiometricType.iris;
    } else {
      return null;
    }
  }

  Future<bool> authHandle() async {
    try {
      return auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}
