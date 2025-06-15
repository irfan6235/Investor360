import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/common_utils.dart';

void sessionExpireHandle() {
  // Get.delete();
  showSnackBar(Get.context!, "Session Expired, Please Login again.");
  Get.toNamed(Routes.loginMpinScreen.name);
}
