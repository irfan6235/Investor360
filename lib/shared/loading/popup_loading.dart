import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_loading_overlay.dart';

class PopUpLoading {
  static onLoading(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomLoadingOverlay(
          isLoading: true,
          child: Container(),
        );
      },
    );
  }

  static onLoadingOff(BuildContext context) {
    Navigator.of(context).pop();
  }

  static loadingOn() {
    Get.dialog(
      CustomLoadingOverlay(
        isLoading: true,
        child: Container(),
      ),
      barrierDismissible: false,
    );
  }

  Widget displayLoading() {
    return CustomLoadingOverlay(
      isLoading: true,
      child: Container(),
    );
  }

  static loadingOff() {
    if (Get.isDialogOpen != null && Get.isDialogOpen!) {
      Get.back();
    }
  }
}