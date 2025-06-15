import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/loading/popup_loading.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/base_response.dart';
import '../../login/model/login_request.dart';

class LoginMpinController extends GetxController {
  RxBool isFingerprintEnable = false.obs;
  RxBool termsCondition = false.obs;
  final LocalAuthentication auth = LocalAuthentication();
  final LoginRepo loginRepo = LoginRepo();
  final RxBool _isAuthenticating = false.obs;
  final RxString _authorized = 'Not Authorized'.obs;
  var hasError = false.obs;
  RxInt count = 0.obs;
  RxString userName = "".obs;
  TextEditingController pinLogin = TextEditingController();

  @override
  void onInit() async {
    pinLogin.clear();
    await getName();
    super.onInit();
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString(KeyConstants.name);
    if (name != null) {
      userName.value = name.toString();
    } else {
      userName.value = "";
    }

    //print(userName.value);
    return name.toString();
  }

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

      prefs.setBool(KeyConstants.isFingerprintEnabled, true);

      mpinLoginApi();
      //  Get.toNamed(Routes.dashboardScreen.name);
    }
  }

  Future<void> mpinLoginApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pan = prefs.getString(KeyConstants.pan);
    var mobile = prefs.getString(KeyConstants.mobileKey);

    LoginRequest mpinRequest = LoginRequest();
    mpinRequest.channelId = "Device";
    mpinRequest.deviceId = await getDeviceId();
    mpinRequest.deviceOS = getDeviceOS();
    mpinRequest.pan = pan;
    mpinRequest.mobile = mobile;
    mpinRequest.signCS = getSignChecksum(mpinRequest.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await loginRepo.mpinLoginApi(mpinRequest);
      print(res);
      CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
      if (res != null && res.statusCode == 200) {
        if (response.responseCode == "0") {
          PopUpLoading.onLoadingOff(Get.context!);
          print("Success Mpin Login");
          prefs.setString(KeyConstants.sessionId, response.sessionId!);
          Get.toNamed(Routes.dashboardScreen.name);
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Device is not Registered.") {
            PopUpLoading.onLoadingOff(Get.context!);
            await prefs.clear();
            showSnackBar(Get.context!, response.message ?? "An error occurred");
            Get.toNamed(Routes.loginScreen.name);
          } else {
            PopUpLoading.onLoadingOff(Get.context!);
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      // showSnackBar(Get.context!, "Failed to load data");
      // throw Exception('Failed to load data');
    }
  }
}
