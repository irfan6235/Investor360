import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/login/controller/mpin_setup_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:investor360/widgets/powered_by.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes.dart';

class MpinSetup extends StatelessWidget {
  final MpinSetupController controller = Get.put(MpinSetupController());

  MpinSetup({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    final focusNodeMpin2 = FocusNode();

    return WillPopScope(
      onWillPop: () async {
        bool didNavigate = await controller.navigateToLogin();
        return didNavigate;
      },
      child: Scaffold(
        backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        resizeToAvoidBottomInset: false,

        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              controller.hasError.value = false;
                              controller.mpin1.clear();
                              controller.mpin2.clear();
                              Get.toNamed(Routes.loginScreen.name);
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            StringConstants.mpinSetupText,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 25,color: darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Enter new PIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16,color: darkMode ? Colors.white : Colors.black,),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                controller.isObscured.toggle();
                              },
                              child: SvgPicture.asset(
                                controller.isObscured.value
                                    ? 'assets/eye-slash-hidden.svg'
                                    : 'assets/eye.svg',
                                color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: PinCodeTextField(
                          textStyle:  TextStyle(color: darkMode ? Colors.white : Colors.black,),
                          keyboardType: TextInputType.number,
                          controller: controller.mpin1,
                          appContext: context,
                          length: 6,
                          obscureText: controller.isObscured.value,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            inactiveColor: controller.hasError.value
                                ? Colors.red
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the value as needed
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            OnlyDigitsInputFormatter(),
                          ],
                          beforeTextPaste: (text) {
                            return false; // Disable pasting
                          },
                          onChanged: (value) {
                            controller.hasError.value = false;
                          },
                          onCompleted: (value) {
                            FocusScope.of(context).requestFocus(focusNodeMpin2);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Confirm PIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16,color: darkMode ? Colors.white : Colors.black,),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                controller.isObscuredMpin2.toggle();
                              },
                              child: SvgPicture.asset(
                                controller.isObscuredMpin2.value
                                    ? 'assets/eye-slash-hidden.svg'
                                    : 'assets/eye.svg',
                                color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: PinCodeTextField(
                          textStyle:  TextStyle(color: darkMode ? Colors.white : Colors.black,),
                          keyboardType: TextInputType.number,
                          controller: controller.mpin2,
                          focusNode: focusNodeMpin2,
                          appContext: context,
                          obscureText: controller.isObscuredMpin2.value,
                          length: 6,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            inactiveColor: controller.hasError.value
                                ? Colors.red
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            OnlyDigitsInputFormatter(),
                          ],
                          beforeTextPaste: (text) {
                            return false; // Disable pasting
                          },

                          onChanged: (value) {
                            controller.hasError.value = false;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Investor360Button(
                            buttonText: "Submit",
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              if (controller.mpin1.text.isEmpty ||
                                  controller.mpin2.text.isEmpty) {
                                controller.hasError.value = true;
                                showSnackBar(context, "Please enter MPIN");
                              } else if (controller.mpin1.text.length <= 5) {
                                controller.mpin1.clear();
                                controller.hasError.value = true;
                                showSnackBar(context, "Please enter MPIN");
                              } else if (controller.mpin1.text ==
                                  controller.mpin2.text) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    KeyConstants.mpin, controller.mpin2.text);
                                controller.isObscured.value = true;
                                controller.isObscuredMpin2.value = true;
                                controller.registerDeviceApi();
                                controller.mpin1.clear();
                                controller.mpin2.clear();
                                controller.hasError.value = false;

                                //Get.toNamed(Routes.mpinSuccessScreen.name);
                              } else {
                                controller.mpin2.clear();
                                controller.hasError.value = true;
                                showSnackBar(context, "MPIN does not match ");
                              }
                            },
                          )
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     FocusScope.of(context).unfocus();

                          //     if (mpin1.text.isEmpty || mpin2.text.isEmpty) {
                          //       controller.hasError.value = true;
                          //       showSnackBar(context, "Please enter MPIN");
                          //     } else if (mpin1.text.length <= 5) {
                          //       mpin1.clear();
                          //       controller.hasError.value = true;
                          //       showSnackBar(context, "Please enter MPIN");
                          //     } else if (mpin1.text == mpin2.text) {
                          //       SharedPreferences prefs =
                          //           await SharedPreferences.getInstance();
                          //       prefs.setString(KeyConstants.mpin, mpin2.text);
                          //       controller.isObscured.value = true;
                          //       controller.isObscuredMpin2.value = true;
                          //       controller.registerDeviceApi();
                          //       mpin1.clear();
                          //       mpin2.clear();
                          //       controller.hasError.value = false;

                          //       //Get.toNamed(Routes.mpinSuccessScreen.name);
                          //     } else {
                          //       mpin2.clear();
                          //       controller.hasError.value = true;
                          //       showSnackBar(context, "MPIN does not match ");
                          //     }
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor:
                          //         NsdlInvestor360Colors.bottomCardHomeColour2,
                          //     minimumSize: const Size(double.infinity, 50),
                          //   ),
                          //   child: Text(
                          //     "Submit",
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         fontFamily: GoogleFonts.lato().fontFamily,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w400),
                          //   ),
                          // ),
                          ),
                    ],
                  );
                }),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PoweredBy( darkMode ? Colors.white : Colors.black54,),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
