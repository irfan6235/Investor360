import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/base_request.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/loading/popup_loading.dart';
import '../../../utils/base_response.dart';
import '../../../utils/string_constants.dart';

class MpinSetupController extends GetxController {
  TextEditingController mpin1 = TextEditingController();
  TextEditingController mpin2 = TextEditingController();
  final LoginRepo loginRepo = LoginRepo();
  var isObscured = true.obs;
  var isObscuredMpin2 = true.obs;
  var hasError = false.obs;
  bool navigateToLogin() {
    Get.toNamed(Routes.loginScreen.name);
    return true;
  }

  Future<void> registerDeviceApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    BaseRequest baseRequest = BaseRequest();
    baseRequest.channelId = "Device";
    baseRequest.deviceId = await getDeviceId();
    baseRequest.deviceOS = getDeviceOS();
    baseRequest.sessionId = sessionId;
    baseRequest.signCS = getSignChecksum(baseRequest.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);

      var res = await loginRepo.registerDeviceApi(baseRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

        if (response.responseCode == "0") {
          PopUpLoading.onLoadingOff(Get.context!);
          print("success register device");

          Get.toNamed(Routes.mpinSuccessScreen.name);
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          PopUpLoading.onLoadingOff(Get.context!);
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }
}
