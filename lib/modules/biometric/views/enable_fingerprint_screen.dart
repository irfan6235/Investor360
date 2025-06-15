import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/biometric/controller/fingerprint_Controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:investor360/widgets/powered_by.dart';
import '../../../routes/routes.dart';

class EnableFingerPrintScreen extends StatelessWidget {
  final FingerprintController controller = Get.put(FingerprintController());

  EnableFingerPrintScreen({super.key});
  void _showModalBottomSheet2(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    showModalBottomSheet(
      backgroundColor:  darkMode ?NsdlInvestor360Colors.darkmodeBlack : Colors.white,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          // WillPopScope to handle system back button press
          onWillPop: () async {
            controller.isFingerprintEnable.value = false;
            return true; // Return true to allow popping the modal
          },
          child: SizedBox(
            height: 350,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Confirmation",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                   Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Are you sure you want to enable a biometric authentication?",
                      style: TextStyle(
                          color: darkMode ? Colors.white :Color(0xFF434343),
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Investor360Button(
                          onTap: () async {
                            controller.authenticateWithBiometrics(context);
                          },
                          buttonText: "Yes, Enable")
                      // ElevatedButton(
                      //   onPressed: () {
                      //     controller.authenticateWithBiometrics(context);
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         NsdlInvestor360Colors.bottomCardHomeColour2,
                      //     minimumSize: const Size(double.infinity, 50),
                      //   ),
                      //   child: const Text(
                      //     "Yes, Enable",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          controller.isFingerprintEnable.value = false;
                          Get.back();
                        },
                        child: const Text(
                          "No, Cancel",
                          style: TextStyle(
                              color: Color(0xFF2958FF),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Scaffold(
      backgroundColor: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.loginMpinScreen.name);
                    //  context.pushReplacement(LOGIN.toPath());
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF2958FF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                Platform.isAndroid
                    ? "Face ID/Fingerprint Biometric\nAuthentication"
                    : "Face ID/Fingerprint Biometric\nAuthentication",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 27),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(width: 20),
                Image.asset(
                  Platform.isAndroid
                      ? 'assets/fingerprint.png'
                      : 'assets/faceid.png',
                  color:  darkMode ? Colors.white: NsdlInvestor360Colors.bottomCardHomeColour2,
                  height: 50,
                ),
                const SizedBox(width: 25),
                Text(
                  Platform.isAndroid ? "EnableFingerPrint/\nEnable Face ID" : "EnableFingerPrint/\nEnable Face ID",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Obx(
                    () => Switch(
                        value: controller.isFingerprintEnable.value,
                        onChanged: (value) {
                          controller.isFingerprintEnable.value = value;
                          if (value == true) {
                            _showModalBottomSheet2(context);
                          }
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Through  ${Platform.isAndroid ? "FingerPrint/Face ID" : "FingerPrint/Face ID"}  biometric setup you will be able to login to investor 360 mobile app instantly, with any biometric saved in your device."
                "\n\n You will not be able to use this feature for truncations.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.termsCondition.value,
                      onChanged: (value) {
                        controller.termsCondition.value = value!;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: "I have read and agree to the ",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: darkMode? Colors.white:Colors
                                  .black, // Customize text color if needed
                            ),
                          ),
                          const TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                              color: Color(0xFF2958FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Investor360Button(
                    onTap: () async {
                      if (controller.termsCondition.value == false) {
                        showErrorDialog(
                            "Please Accept Terms and Conditions", context);
                      } else {
                        Get.toNamed(Routes.loginMpinScreen.name);
                      }
                    },
                    buttonText: "Submit")
                //  ElevatedButton(
                //   onPressed: () async {
                //     if (controller.termsCondition.value == false) {
                //       showErrorDialog(
                //           "Please Accept Terms and Conditions", context);
                //     } else {
                //       Get.toNamed(Routes.loginMpinScreen.name);
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
                //     minimumSize: const Size(double.infinity, 50),
                //   ),
                //   child: const Text(
                //     "Submit",
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.w400,
                //         fontSize: 20),
                //   ),
                // ),
                ),
            const SizedBox(height: 20),
            PoweredBy(darkMode ? Colors.white:Colors.grey),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
