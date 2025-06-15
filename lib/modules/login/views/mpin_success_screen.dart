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

class MpinSuccessScreen extends StatelessWidget {
  final controller = Get.put(MpinSuccessController());
  MpinSuccessScreen({super.key});

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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                   Text(
                                    "Your M-PIN has been successfully created. Now you can securely access your account.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25,
                                      color:  darkMode ? Colors.white:Colors.black
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  Investor360Button(
                                    buttonText: "Go to Login Page",
                                    onTap: () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool(
                                          KeyConstants.isLoggedIn, true);
                                      Get.toNamed(Routes.loginMpinScreen.name);
                                    },
                                  ),
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
                      child: PoweredBy( darkMode ? Colors.white:Colors.black54),
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
