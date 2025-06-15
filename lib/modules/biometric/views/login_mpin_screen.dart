import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/biometric/controller/login_mpin_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/evoting/views/e_voting.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:investor360/widgets/powered_by.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes.dart';
import '../../../utils/string_constants.dart';

class LoginMpinScreen extends StatefulWidget {
  const LoginMpinScreen({super.key});

  @override
  State<LoginMpinScreen> createState() => _LoginMpinScreenState();
}

class _LoginMpinScreenState extends State<LoginMpinScreen> {
  final LoginMpinController controller = Get.put(LoginMpinController());
  TextEditingController mpin = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration:  const BoxDecoration(
                    color: /* darkMode ? NsdlInvestor360Colors.bottomCardHomeColour2Dark :*/ NsdlInvestor360Colors.bottomCardHomeColour2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/small_Abstract.png',
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.8,
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 27,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.loginScreen.name);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 10, right: 20),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Reset it",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.7,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 57, left: 0),
                          child: Container(
                            width:
                                100, // Adjust width to fit the rounded container
                            height:
                                100, // Adjust height to fit the rounded container
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  60), // Makes the container circular
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/usernew.png',
                                height: 100,
                              ),
                              /*SvgPicture.asset(
                                'assets/userimg.svg',
                              ),*/
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                                controller.userName.value.isNotEmpty
                                    ? "Hello, ${controller.userName.value}"
                                    : "Hey there!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 23,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          decoration:  BoxDecoration(
                            color: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 27, left: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(
                                    () => Text(
                                      controller.userName.value.isNotEmpty
                                          ? "Welcome back!"
                                          : "Welcome! ",
                                      textAlign: TextAlign.left,
                                      style:  TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 22.5,
                                          color: darkMode ? NsdlInvestor360Colors.white : Colors.black,),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                               Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Login with M-PIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      color: darkMode ? NsdlInvestor360Colors.white : Colors.black,),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Obx(
                                  () => PinCodeTextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      controller.hasError.value = false;
                                    },
                                    onCompleted: (String value) async {
                                      FocusScope.of(context).unfocus();
            
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var mpincheck =
                                          prefs.getString(KeyConstants.mpin);
                                      //print(value);
                                      if (value == mpincheck) {
                                        controller.mpinLoginApi();
                                        controller.pinLogin.clear();
                                        // Get.toNamed(Routes.dashboardScreen.name);
                                      } else {
            
                                        controller.count.value++;
            
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString(KeyConstants.mpin_count, controller.count.value.toString());
                                        var mpinCount = prefs.getString(KeyConstants.mpin_count);
                                      //  print("shared "+ mpinCount.toString());
            
                                       // var mpinCount = prefs.getString(KeyConstants.mpin_count);
                                      //  mpinCount = controller.count.value.toString();
                                        controller.pinLogin.clear();
                                        controller.hasError.value = true;
                                        showSnackBar(context, "Incorrect Mpin");
            
                                       // var mpinCount = prefs.getString(KeyConstants.mpin_count);
                                        if (mpinCount != null && int.parse(mpinCount) > 5) {
                                          controller.count.value = 0;
                                          controller.hasError.value = false;
                                          showSnackBar(Get.context!, "Redirected to login due to 5 failed attempts." ?? "An error occurred");
                                          clearAllSharedPreferences();
                                          Get.offNamed(Routes.loginScreen.name);
                                        }
            //print(mpinCount);
            
                                      }
                                    },
                                    controller: controller.pinLogin,
                                    appContext: context,
                                    length: 6,
                                    obscureText: true,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      inactiveColor: controller.hasError.value
                                          ? Colors.red
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle:  TextStyle(color: darkMode ? Colors.white : Colors.black,),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: InkWell(
                                  onTap: () {
                                    clearAllSharedPreferences();
                                    Get.offNamed(Routes.loginScreen.name);
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Forgot Mpin?",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          color: darkMode ? NsdlInvestor360Colors.white : NsdlInvestor360Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                        indent: 60,
                                        color: NsdlInvestor360Colors.lightGrey7),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "OR",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: NsdlInvestor360Colors.lightGrey7,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                        endIndent: 60,
                                        color: NsdlInvestor360Colors.lightGrey7),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var check = prefs
                                      .getBool(KeyConstants.isFingerprintEnabled);
            
                                  if (check == true) {
                                    controller
                                        .authenticateWithBiometrics(context);
                                  } else {
                                    _showModalBottomSheet2(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Image.asset(
                                    Platform.isAndroid
                                        ? 'assets/fingerprint.png'
                                        : 'assets/faceid.png',
                                    color:
                                    darkMode ? NsdlInvestor360Colors.white :
                                    NsdlInvestor360Colors
                                        .bottomCardHomeColourLightest,
                                    scale: 2.2,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    Platform.isAndroid
                                        ? "Login using Face ID/Fingerprint"
                                        : "Login using Face ID/Fingerprint",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: GoogleFonts.lato().fontFamily,
                                        color:
                                        darkMode ? NsdlInvestor360Colors.white :   NsdlInvestor360Colors.bottomCardHomeColourLightest),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                               Padding(
                                padding: EdgeInsets.only(bottom: 17),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: PoweredBy(darkMode ? NsdlInvestor360Colors.white : Colors.black,),
                                ),
                              ),
                              //  const SizedBox(height: 70),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*   const Padding(
                  padding: EdgeInsets.only(bottom: 17),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PoweredBy(Colors.black54),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Information",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500  ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Kindly enable ${Platform.isAndroid ? "Fingerprint/Face ID" : "Fingerprint/Face ID"} Authentication.",
                      style:  TextStyle(
                          color:  darkMode ?NsdlInvestor360Colors.white :  Color(0xFF434343),
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Investor360Button(
                          onTap: () async {
                            Get.toNamed(Routes.enableBiometricScreen.name);
                          },
                          buttonText: "Okay")
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Get.toNamed(Routes.enableBiometricScreen.name);
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         NsdlInvestor360Colors.bottomCardHomeColour2,
                      //     minimumSize: const Size(double.infinity, 50),
                      //   ),
                      //   child: const Text(
                      //     "Okay",
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
        );
      },
    );
  }
}
