import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:developer' as dev;
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

showSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(message, style: const TextStyle(color: Colors.white)));
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBarCustom(String title,String message, Color backgroundColor, IconData icon) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    icon:  Icon(icon, color: Colors.white),
    duration: const Duration(seconds: 3),
  );
}


Future<void> clearAllSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

extension ExpansionTileExtension on ExpansionTile {
  Widget applyTheme(Color dividerColor) {
    return Theme(
      data: ThemeData(
        dividerColor: dividerColor,
      ),
      child: this,
    );
  }
}



String? getSignChecksum(String concatedString, String appSignkey) {
  dev.log(concatedString);
  try {

    print("Concated String=");
    print(concatedString);

    print("App Sign Key=");
    print(appSignkey.toString());

    if (appSignkey.isEmpty) {
      appSignkey = "123456";
     // print("App Sign Key="+appSignkey);
    }

    // Encode the app sign key and concatenated string to bytes
    List<int> appSignKeyBytes = utf8.encode(appSignkey);
    List<int> bytesCS = utf8.encode(concatedString);

    // Create HMAC-SHA512 using the app sign key bytes
    var hmacSha512 = Hmac(sha512, appSignKeyBytes);

    // Compute the HMAC and encode the result to Base64
    String hash = base64.encode(hmacSha512.convert(bytesCS).bytes);

    print("Sign CS");
    print(hash.trim());

    return hash.trim();
  } catch (e) {
    print("Error Catch=" + e.toString());
    return null;
  }
}


Future<String?> getDeviceId() async {
  String? deviceId;
  try {
    deviceId = await PlatformDeviceId.getDeviceId;
    bool isEmulator = await _isSimulatorOrEmulator();
    if (isEmulator) {
      deviceId = 'deviceIDSimulator';
    }
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }
  return deviceId;
}

Future<bool> _isSimulatorOrEmulator() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isEmulator = false;

  if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    isEmulator = !iosInfo.isPhysicalDevice;
  } else if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isEmulator = !androidInfo.isPhysicalDevice;
  }

  return isEmulator;
}


String getDeviceOS() {
  if (kIsWeb) {
    return "WEB";
  } else if (Platform.isIOS) {
    return "iOS";
  } else if (Platform.isAndroid) {
    return "Android";
  } else if (Platform.isMacOS) {
    return "MACOS";
  } else if (Platform.isLinux) {
    return "LINUX";
  } else if (Platform.isWindows) {
    return "WINDOWS";
  } else {
    return "UNKNOWN";
  }
}



