import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/change_mpin_controller.dart';

class ChangeMpinScreen extends StatefulWidget {
  const ChangeMpinScreen({super.key});

  @override
  State<ChangeMpinScreen> createState() => _ChangeMpinScreenState();
}

class _ChangeMpinScreenState extends State<ChangeMpinScreen> {
  final ChangeMpinController controller = Get.put(ChangeMpinController());

  final _advancedDrawerController = AdvancedDrawerController();

  // final FocusNode focusNodeMpin2 = FocusNode();

  // final FocusNode focusNodeMpin3 = FocusNode();

  @override
  void dispose() {
    // focusNodeMpin2.dispose();
    // focusNodeMpin3.dispose();
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.dashboardScreen.name);
        return false;
      },
      child:
          // AdvancedDrawer(
          //   backdrop: Container(
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage('assets/drawerAbstract.png'),
          //         fit: BoxFit.fitWidth,
          //         alignment: Alignment.topLeft,
          //       ),
          //       gradient: LinearGradient(
          //         colors: [
          //           NsdlInvestor360Colors.bottomCardHomeColour2,
          //           NsdlInvestor360Colors.bottomCardHomeColour0,
          //         ],
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //       ),
          //     ),
          //   ),
          //   backdropColor: Colors.transparent,
          //   controller: _advancedDrawerController,
          //   animationCurve: Curves.easeInOut,
          //   animationDuration: const Duration(milliseconds: 300),
          //   animateChildDecoration: true,
          //   rtlOpening: false,
          //   disabledGestures: false,
          //   childDecoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(44)),
          //     boxShadow: [
          //       BoxShadow(
          //         color: NsdlInvestor360Colors.drowShodowDrawerColor,
          //         blurRadius: 1.0, // Softness of the shadow
          //         spreadRadius: -90.0, // Extent of the shadow
          //         offset: Offset(-140, -10), // Position of the shadow (x, y)
          //       ),
          //     ],
          //   ),
          //   drawer: CustomDrawer(
          //     advancedDrawerController: _advancedDrawerController,
          //   ),
          // child:
          Scaffold(
            backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.pureWhite,
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "Change Mpin",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkMode? Colors.white :Colors.black,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
          leading: IconButton(
            icon:  Icon(
              Icons.arrow_back,
              color: darkMode? Colors.white :Colors.black,
            ),
            onPressed: () {
              // Navigator.of(context).pop();
              Get.toNamed(Routes.dashboardScreen.name);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Enter old PIN",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        controller.isObscured.toggle();
                      },
                      child: Obx(() => SvgPicture.asset(
                            controller.isObscured.value
                                ? 'assets/eye-slash-hidden.svg'
                                : 'assets/eye.svg',
                        color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Obx(
                    () => PinCodeTextField(
                      keyboardType: TextInputType.number,
                      controller: oldPassword,
                      appContext: context,
                      length: 6,
                      obscureText: controller.isObscured.value,
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
                      onCompleted: (value) {
                        // FocusScope.of(context).requestFocus(focusNodeMpin2);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Enter new PIN",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        controller.isObscuredMpin2.toggle();
                      },
                      child: Obx(() => SvgPicture.asset(
                            controller.isObscuredMpin2.value
                                ? 'assets/eye-slash-hidden.svg'
                                : 'assets/eye.svg',
                        color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Obx(() => PinCodeTextField(
                        keyboardType: TextInputType.number,
                        controller: newPassword,
                        // focusNode: focusNodeMpin2,
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
                        onCompleted: (value) {
                          // FocusScope.of(context).requestFocus(focusNodeMpin3);
                        },
                      )),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Confirm new PIN",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        controller.isObscuredMpin3.toggle();
                      },
                      child: Obx(() => SvgPicture.asset(
                            controller.isObscuredMpin3.value
                                ? 'assets/eye-slash-hidden.svg'
                                : 'assets/eye.svg',
                        color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Obx(() => PinCodeTextField(
                        keyboardType: TextInputType.number,
                        controller: confirmPassword,
                        // focusNode: focusNodeMpin3,
                        appContext: context,
                        obscureText: controller.isObscuredMpin3.value,
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
                      )),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Investor360Button(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var mpincheck = prefs.getString(KeyConstants.mpin);
                          if (confirmPassword.text.isEmpty ||
                              newPassword.text.isEmpty ||
                              oldPassword.text.isEmpty) {
                            controller.hasError.value = true;
                            showSnackBar(context, "Please enter MPIN");
                          } else if (oldPassword.text.length <= 5) {
                            oldPassword.clear();
                            controller.hasError.value = true;
                            showSnackBar(
                                context, "Please enter Valid Old Mpin");
                          } else if (oldPassword.text != mpincheck) {
                            oldPassword.clear();
                            controller.hasError.value = true;
                            showSnackBar(context, "Old Password is Incorrect");
                          } else if (newPassword.text.length <= 5) {
                            newPassword.clear();
                            confirmPassword.clear();
                            controller.hasError.value = true;
                            showSnackBar(
                                context, "Please enter Valid New Mpin");
                          } else if (oldPassword.text == confirmPassword.text) {
                            newPassword.clear();
                            confirmPassword.clear();
                            controller.hasError.value = true;
                            showSnackBar(context,
                                "New Mpin and Old Mpin cannot be same");
                          } else if (newPassword.text == confirmPassword.text) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                KeyConstants.mpin, confirmPassword.text);
                            oldPassword.clear();
                            newPassword.clear();
                            confirmPassword.clear();
                            controller.hasError.value = false;
                            controller.isObscured.value = true;
                            controller.isObscuredMpin2.value = true;
                            controller.isObscuredMpin3.value = true;
                            Get.toNamed(Routes.loginMpinScreen.name);
                          } else {
                            confirmPassword.clear();
                            controller.hasError.value = true;
                            showSnackBar(context, "New MPIN does not match ");
                          }
                        },
                        buttonText: "Submit")
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     FocusScope.of(context).unfocus();
                    //     SharedPreferences prefs =
                    //         await SharedPreferences.getInstance();
                    //     var mpincheck = prefs.getString(KeyConstants.mpin);
                    //     if (confirmPassword.text.isEmpty ||
                    //         newPassword.text.isEmpty ||
                    //         oldPassword.text.isEmpty) {
                    //       controller.hasError.value = true;
                    //       showSnackBar(context, "Please enter MPIN");
                    //     } else if (oldPassword.text.length <= 5) {
                    //       oldPassword.clear();
                    //       controller.hasError.value = true;
                    //       showSnackBar(context, "Please enter Valid Old Mpin");
                    //     } else if (oldPassword.text != mpincheck) {
                    //       oldPassword.clear();
                    //       controller.hasError.value = true;
                    //       showSnackBar(context, "Old Password is Incorrect");
                    //     } else if (newPassword.text.length <= 5) {
                    //       newPassword.clear();
                    //       confirmPassword.clear();
                    //       controller.hasError.value = true;
                    //       showSnackBar(context, "Please enter Valid New Mpin");
                    //     } else if (oldPassword.text == confirmPassword.text) {
                    //       newPassword.clear();
                    //       confirmPassword.clear();
                    //       controller.hasError.value = true;
                    //       showSnackBar(
                    //           context, "New Mpin and Old Mpin cannot be same");
                    //     } else if (newPassword.text == confirmPassword.text) {
                    //       SharedPreferences prefs =
                    //           await SharedPreferences.getInstance();
                    //       prefs.setString(KeyConstants.mpin, confirmPassword.text);
                    //       oldPassword.clear();
                    //       newPassword.clear();
                    //       confirmPassword.clear();
                    //       controller.hasError.value = false;
                    //       controller.isObscured.value = true;
                    //       controller.isObscuredMpin2.value = true;
                    //       controller.isObscuredMpin3.value = true;
                    //       Get.toNamed(Routes.loginMpinScreen.name);
                    //     } else {
                    //       confirmPassword.clear();
                    //       controller.hasError.value = true;
                    //       showSnackBar(context, "New MPIN does not match ");
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor:
                    //         NsdlInvestor360Colors.bottomCardHomeColour2,
                    //     minimumSize: const Size(double.infinity, 50),
                    //   ),
                    //   child: const Text(
                    //     "Submit",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

TextEditingController oldPassword = TextEditingController();
TextEditingController newPassword = TextEditingController();
TextEditingController confirmPassword = TextEditingController();
