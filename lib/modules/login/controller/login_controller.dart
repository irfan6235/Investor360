import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/environment/env.dart';
import 'package:investor360/modules/login/model/check_device.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/base_request.dart';
import '../../../utils/base_response.dart';
import '../data/login_repo.dart';
import '../model/login_request.dart';

class LoginController extends GetxController {
  TextEditingController mobile = TextEditingController();
  TextEditingController pan = TextEditingController();
  var isLoading = false.obs;
  bool captchaverify = true;
  final LoginRepo loginRepo = LoginRepo();
  RxString mobileNumber = RxString("");

  Future<bool> onSubmit(BuildContext context) async {
    if (mobile.text.isEmpty) {
      mobile.clear();
      showSnackBar(context, "Please Enter Mobile No");
      return false;
    } else if (!isValidPhoneNumber(mobile.text)) {
      mobile.clear();
      showSnackBar(context, "Please Enter Valid Mobile No");
      return false;
    } else if (captchaverify == false) {
      showSnackBar(context, "Please do the human Verification");
      return false;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(KeyConstants.mobileKey, mobile.text);
      await prefs.setString(KeyConstants.pan, pan.text);
      return true;
    }
  }

  void validatePan(BuildContext context) async {
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    isLoading.value = true;
    if (pan.text.isEmpty) {
      pan.clear();
      isLoading.value = false;
      showSnackBar(context, "Please Enter PAN Number");
    } else if (pan.text.length != 10) {
      pan.clear();
      isLoading.value = false;
      showSnackBar(context, "Please Enter valid PAN Number");
    } else if (!panRegex.hasMatch(pan.text)) {
      pan.clear();
      isLoading.value = false;
      showSnackBar(context, 'Invalid PAN format');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mobile = prefs.getString(KeyConstants.mobileKey);
      fetchData(pan.text, mobile!);
    }
  }


  Future<void> fetchData(String pan, String mobile) async {
    LoginRequest loginRequest = LoginRequest();
    loginRequest.channelId = "Device";
    loginRequest.deviceId = await getDeviceId();
    loginRequest.deviceOS = getDeviceOS();
    loginRequest.pan = pan;
    loginRequest.mobile = mobile;
    loginRequest.signCS = getSignChecksum(loginRequest.toString(), "");

    try {
      var res = await loginRepo.loginApi(loginRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

       // BaseResponse<ResponseClass> response = BaseResponse.fromJson(res.data,
            //  (dataJson) => ResponseClass.fromJson(dataJson),);

        if (response.responseCode == "0") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(KeyConstants.sessionId, response.sessionId ?? '');
          print("the session id is " + (response.sessionId ?? ''));
          isLoading.value = false;
          Get.delete<LoginController>();
          Get.toNamed(Routes.loginOTPScreen.name);
        } else if (response.responseCode == "1" || response.responseCode == "-1") {
          isLoading.value = false;
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print("#Exception" + e.toString());
      isLoading.value = false;
      showSnackBar(Get.context!, "Failed to load data");

      throw Exception('Failed to load data');
    }
  }


/*  Future<void> fetchData(String pan, String mobile) async {
    LoginRequest loginRequest = LoginRequest();
    loginRequest.channelId=  "Web";
    loginRequest.deviceId= "abcd12ka4";
    loginRequest.deviceOS=  "meraOS";

    loginRequest.pan= pan;
    loginRequest.mobile= mobile;

    loginRequest.signCS = getSignChecksum(loginRequest.toString(), "");

    try {
      var res = await loginRepo.loginApi(loginRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        final jsonResponse = res.data;
        final sessionId = jsonResponse['sessionId'];
        final otp = jsonResponse['otp'] ?? 'No OTP provided';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(KeyConstants.sessionId, sessionId);
        print("the session id is " + sessionId);
        isLoading.value = false;
        Get.delete<LoginController>();
        Get.toNamed(Routes.loginOTPScreen.name);
      }
    } catch (e) {
      print("#Exception" + e.toString());
      throw Exception('Failed to load data');
    }
  }*/

  bool isValidPhoneNumber(String input) {
    // Check if the input is a valid Indian mobile number
    final isPhoneNumber = RegExp(r'^[6789]\d{9}$').hasMatch(input);
    return isPhoneNumber;
  }

  void navigateToLoginPanScren() {
    Get.back();
    Get.toNamed(Routes.loginPanScreen.name);
  }

  @override
  void dispose() {
    mobile.dispose();
    pan.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    clearTextFields();
  }

  @override
  void onReady() {
    super.onReady();
    clearTextFields();
  }

  void clearTextFields() {
    mobile.clear();
    pan.clear();
  }

  void launchUrl(BuildContext context) async {
    const url = 'https://uat-api.nsdl.com/client-registration';

    await launch(url);
  }
}
