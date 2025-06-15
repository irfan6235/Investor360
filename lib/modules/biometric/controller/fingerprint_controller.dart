import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FingerprintController extends GetxController {
  RxBool isFingerprintEnable = false.obs;
  RxBool termsCondition = true.obs;
  final LocalAuthentication auth = LocalAuthentication();
  final RxBool _isAuthenticating = false.obs;
  final RxString _authorized = 'Not Authorized'.obs;

  // Function to trigger biometric authentication
  Future<void> authenticateWithBiometrics(BuildContext context) async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      showErrorDialog("Please Try again Later", context);
      // Biometric authentication is not available on this device.
      return;
    }
    bool authenticated = false;
    try {
      _isAuthenticating.value = true;
      _authorized.value = 'Authenticating';

      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint  to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      _isAuthenticating.value = false;
      _authorized.value = 'Authenticating';
    } on PlatformException catch (e) {
      showErrorDialog("Biometric not Supported", context);
      if (kDebugMode) {
        print(e);
      }

      _isAuthenticating.value = false;
      _authorized.value = 'Error - ${e.message}';

      return;
    }
    // if (!mounted) {
    //   return;
    // }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    _authorized.value = message;

    // Perform actions based on authentication result
    if (authenticated) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Get.toNamed(Routes.fingerprintsuccessScreen.name);
      prefs.setBool(KeyConstants.isFingerprintEnabled, true);
    }
  }
}
