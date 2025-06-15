import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MpinSuccessController extends GetxController {
  void closeKeyboard(context) {
    FocusScope.of(context).unfocus();
  }
}
