import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/login/controller/mpin_success_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:investor360/widgets/powered_by.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FingerprintSuccessScreen extends StatelessWidget {
  final controller = Get.put(MpinSuccessController());
  FingerprintSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    controller.closeKeyboard(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.greenlightback,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 85),
                            child: Center(
                              child: Image.asset('assets/done_image.png'),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Container(
                            decoration:  BoxDecoration(
                              color:  darkMode ? NsdlInvestor360Colors.bottomCardHomeColour2:Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                      "${Platform.isAndroid ? "Fingerprint/Face ID" : "Fingerprint/Face ID"} authentication has been enabled successfully. You can now use ${Platform.isAndroid ? "fingerprint" : "Face ID"}  authentication to login on investor 360 mobile. ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 22,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                   Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "To disable, please go to settings under the main menu option",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: darkMode? Colors.white60:Color(0xFF616161)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Investor360Button(
                                      buttonText: "Go to Login Page",
                                      onTap: () async {
                                        Get.toNamed(
                                            Routes.loginMpinScreen.name);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child:  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: PoweredBy( darkMode? Colors.white:Colors.black54),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
