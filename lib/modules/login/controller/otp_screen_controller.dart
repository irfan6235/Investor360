import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
import 'package:investor360/modules/login/model/resend_Otp_request.dart';
import 'package:investor360/modules/login/model/validateOtp_request.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreenController extends GetxController {
  RxInt _start = 60.obs; // RxInt for reactive integer
  RxBool isInputDisabled = false.obs;
  late Timer timer;
  final ValidateOTPAPI validaterepo = ValidateOTPAPI();
  var hasError = false.obs;
  TextEditingController pin = TextEditingController();

  RxInt get start => _start;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {//re%#@r
      if (_start.value == 0) {
        isInputDisabled.value = true;
        timer.cancel();
      } else {
        _start.value--;
      }
    });
  }

  void resetTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {});
    if (timer.isActive) {
      timer.cancel();
    }
    _start.value = 60; // Reset the timer value
    isInputDisabled.value = false;
    startTimer(); // Restart the timer
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  bool navigateToLogin() {
    Get.toNamed(Routes.loginScreen.name);
    // Get.toNamed(Routes.mpinSetupScreen.name);
    return true;
  }

  // Future<void> validateOtp(String pin, BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var sessionId = prefs.getString(KeyConstants.sessionId);

  //   final url = Uri.parse(ApiUrlEndpoint.validateOtp);
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'sessionId': sessionId,
  //       'otp': pin,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     final otpValidated = jsonResponse['otpValidated'];
  //     final message = jsonResponse['message'] ?? 'No Message provided';
  //     if (otpValidated == "true") {
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setBool(KeyConstants.isLoggedIn, true);
  //       // Get.toNamed(Routes.loginMpinScreen.name);
//       Get.toNamed(Routes.dashboardScreen.name);
  //     } else {
  //       showErrorDialog(
  //           message, context); // Display error dialog if OTP validation fails
  //     }
  //   } else {
  //     showErrorDialog('Entered OTP is incorrect',
  //         context); // Display error dialog for non-200 status code
  //   }
  // }

  void validateOTPField(BuildContext context) {
    if (pin.text.length == 6) {
      validateOtp(pin, context);
    } else {
      pin.clear();
      hasError.value = true;
      showSnackBar(context, "Enter Valid OTP");
    }
  }

  // Future<void> validateOtp(String pin, BuildContext context) async {
  //   ValidateOtpRequest validateOtpRequest = ValidateOtpRequest();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var sessionId = prefs.getString(KeyConstants.sessionId);
  //   validateOtpRequest.sessionId = sessionId;
  //   validateOtpRequest.otp = pin;

  //   try {
  //     var res = await validaterepo.validateOtpApi(validateOtpRequest);
  //     print(res);

  //     if (res != null) {
  //       final jsonResponse = res.data;
  //       final sessionId = jsonResponse['sessionId'];
  //       final message = jsonResponse['message'] ?? 'No Message provided';

  //       if (sessionId != null) {
  //         prefs.setString(KeyConstants.sessionId, sessionId);
  //         prefs.setBool(KeyConstants.isLoggedIn, true);
  //         Get.toNamed(Routes.dashboardScreen.name);
  //       } else {
  //         showErrorDialog(message, context);
  //       }
  //     }
  //   } catch (e) {
  //     print("#Exception: " + e.toString());

  //     if (e.toString().contains("Unauthorized")) {
  //       showErrorDialog('Entered OTP is incorrect', context);
  //     } else {
  //       showErrorDialog(
  //           'No Demat Accounts exist with the provided details!', context);
  //     }
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<void> validateOtp(
      TextEditingController pin, BuildContext context) async {
    ValidateOtpRequest validateotp = ValidateOtpRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    validateotp.channelId = "Device";
    validateotp.deviceId = await getDeviceId();
    validateotp.deviceOS = getDeviceOS();
    validateotp.sessionId = sessionId;
    validateotp.otp = pin.text;
    validateotp.signCS = getSignChecksum(validateotp.toString(), "");

    try {
      var res = await validaterepo.validateOtpApi(validateotp);
      print(res);
      CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

      if (res != null && res.statusCode == 200) {
        if (response.responseCode == "0") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(KeyConstants.sessionId, response.sessionId ?? '');
          print("the session id is " + (response.sessionId ?? ''));

          prefs.setBool(KeyConstants.isLoggedIn, true);
          Get.delete<OtpScreenController>();
          Get.toNamed(Routes.mpinSetupScreen.name);

          //     Get.toNamed(Routes.dashboardScreen.name);
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            pin.clear();
            showSnackBar(Get.context!, "Session Expired, Please Login again.");
            Get.toNamed(Routes.loginScreen.name);
          } else if (response.message == "OTP Authentication Failure!") {
            pin.clear();
            showSnackBar(Get.context!, response.message ?? "An error occurred");
            hasError.value = true;
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        showSnackBar(Get.context!, response.message ?? "An error occurred");
      }
    } catch (e) {
      print("#Exception" + e.toString());
    }
  }

  Future<void> ResendOtpAPI() async {
    ResendOtpRequest resendOtpp = ResendOtpRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    resendOtpp.channelId = "Device";
    resendOtpp.deviceId = await getDeviceId();
    resendOtpp.deviceOS = getDeviceOS();
    resendOtpp.sessionId = sessionId;

    resendOtpp.signCS = getSignChecksum(resendOtpp.toString(), "");

    try {
      var res = await validaterepo.resendOtp(resendOtpp);
      print(res);
      CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

      if (res != null && res.statusCode == 200) {
        if (response.responseCode == "0") {
          isInputDisabled.value = false;
          resetTimer();
          print("Success");
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            showSnackBar(Get.context!, "Session Expired, Please Login again.");
            Get.toNamed(Routes.loginScreen.name);
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        showSnackBar(Get.context!, response.message ?? "An error occurred");
      }
    } catch (e) {
      print("#Exception" + e.toString());

      showSnackBar(
          Get.context!, 'No Demat Accounts exist with the provided details!');
    }
  }

  @override
  void dispose() {
    pin.dispose();
    super.dispose();
  }
}
