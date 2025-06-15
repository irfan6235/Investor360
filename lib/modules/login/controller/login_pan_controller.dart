import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
import 'package:investor360/modules/login/model/login_request.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/api_url_endpoint.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPanController extends GetxController {
  TextEditingController pan = TextEditingController();
  var isLoading = false.obs;
  final LoginRepo loginRepo = LoginRepo();
  RxString mobileNumber = RxString(""); // Make mobileNumber reactive

  @override
  void onInit() async {
    await initializeData();
    super.onInit();
  }

  void validatePan(BuildContext context) async {
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    isLoading.value = true;
    if (pan.text.isEmpty) {
      isLoading.value = false;
      showErrorDialog("Please Enter PAN Number", context);
    } else if (pan.text.length != 10) {
      isLoading.value = false;
      showErrorDialog("Please Enter valid PAN Number", context);
    } else if (!panRegex.hasMatch(pan.text)) {
      isLoading.value = false;
      showErrorDialog('Invalid PAN format', context);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mobile = prefs.getString(KeyConstants.mobileKey);
      fetchData(pan.text, mobile!, context);
    }
  }

  Future<void> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber.value = prefs.getString(KeyConstants.mobileKey)!;
  }

/*  Future<void> fetchData(String pan, String mobile) async {
    final url = Uri.parse(ApiUrlEndpoint.login);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pan': pan,
        'mobile': mobile,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final sessionId = jsonResponse['sessionId'];
      final otp = jsonResponse['otp'] ?? 'No OTP provided';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(KeyConstants.sessionId, sessionId);
      print("the session id is " + sessionId);
      isLoading.value = false;
      Get.toNamed(Routes.loginOTPScreen.name);
    } else {
      throw Exception('Failed to load data');
    }
  }*/

  Future<void> fetchData(
      String pan, String mobile, BuildContext context) async {
    LoginRequest loginRequest = LoginRequest();
    loginRequest.pan = pan;
    loginRequest.mobile = mobile;

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
        Get.toNamed(Routes.loginOTPScreen.name);
      } else {
        showErrorDialog("Entered OTP is incorrect", context);
      }
    } catch (e) {
      print("#Exception" + e.toString());
      throw Exception('Failed to load data');
    }
  }
}
