import 'package:get/get.dart';
import 'package:investor360/environment/env.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
import 'package:investor360/modules/login/model/check_device.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

class SplashScreenController extends GetxController {
  final LoginRepo loginRepo = LoginRepo();

  var isRooted = false.obs;
  var isJailbroken = false.obs;
  var devMode = false.obs;
  var rootedCheck = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () async {
      await checkDeviceSecurity();
    });
  }

  Future<void> checkDeviceApi() async {
    CheckDeviceRequest checkDeviceRequest = CheckDeviceRequest();
    checkDeviceRequest.channelId = "Device";
    checkDeviceRequest.deviceId = await getDeviceId();
    checkDeviceRequest.deviceOS = getDeviceOS();
    checkDeviceRequest.appOS = getDeviceOS();
    checkDeviceRequest.appId = Env.APP_DETAILS_PKG;
    checkDeviceRequest.appName = Env.app_name;
    checkDeviceRequest.appReleaseDate = "25-07-2024";
    checkDeviceRequest.appVersion = "1.0";
    checkDeviceRequest.signCS =
        getSignChecksum(checkDeviceRequest.toString(), "");

    try {
      var res = await loginRepo.checkDeviceApi(checkDeviceRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

        if (response.responseCode == "0") {
          print("success");

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var check = prefs.getBool(KeyConstants.isLoggedIn);

          if (check == null || check == false) {
            Get.toNamed(Routes.loginScreen.name);
          } else {
            Get.toNamed(Routes.loginMpinScreen.name);
          }
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  Future<void> checkDeviceSecurity() async {
    try {
      if (Platform.isAndroid) {
        await androidRootChecker();
        await developerMode();
      } else if (Platform.isIOS) {
        await iosJailbreak();
      }
    } on PlatformException {
      isRooted.value = false;
      isJailbroken.value = false;
      devMode.value = false;
    }

    rootedCheck.value = isRooted.value || isJailbroken.value || devMode.value;

    if (rootedCheck.value) {
      await checkDeviceApi();
      // showRootWarning(Get.context!);
    } else {
      await checkDeviceApi();
    }
  }

  void showRootWarning(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            exit(0);
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Security Alert",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "This device is rooted or in developer mode. You cannot use this app.",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> developerMode() async {
    try {
      devMode.value = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode.value = false;
    }
  }

  Future<void> androidRootChecker() async {
    try {
      isRooted.value = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      isRooted.value = false;
    }
  }

  Future<void> iosJailbreak() async {
    try {
      isJailbroken.value = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      isJailbroken.value = false;
    }
  }
}
