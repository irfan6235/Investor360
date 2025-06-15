import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/login/controller/login_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/widgets/button_widget.dart';
import '../../../widgets/powered_by.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  final FocusNode _panFocusNode = FocusNode();

  LoginScreen({super.key});

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return const SizedBox(
          height: 350,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 39),
                  child: Text(
                    StringConstants.smsBindingText,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    Timer(const Duration(seconds: 5), () {
      Get.back();
      Get.toNamed(Routes.loginPanScreen.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor:
              darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(children: [
                    Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: /* darkMode ? NsdlInvestor360Colors.bottomCardHomeColour2Dark : */
                                NsdlInvestor360Colors.bottomCardHomeColour2,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Opacity(
                                opacity: 0.9,
                                child: Image.asset(
                                  'assets/small_Abstract.png',
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 70, left: 30),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    height: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: darkMode
                                        ? NsdlInvestor360Colors.darkmodeBlack
                                        : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 30,
                                          right: 30,
                                        ),
                                        child: Text(
                                          "Please enter the\nphone number",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 28,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30, left: 30),
                                          child: Text(
                                            "Phone Number",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // // Align(
                                      // //   alignment: Alignment.centerLeft,
                                      // //   child: Padding(
                                      // //     padding:
                                      // //         const EdgeInsets.only(left: 30),
                                      // //     child: Row(
                                      // //       children: [
                                      // //         const Text(
                                      // //           "+91 ",
                                      // //           style: TextStyle(
                                      // //             fontWeight: FontWeight.bold,
                                      // //             fontSize: 35,
                                      // //           ),
                                      // //         ),
                                      // //         Expanded(
                                      // //           child: TextField(
                                      // //             controller: controller.mobile,
                                      // //             keyboardType:
                                      // //                 TextInputType.phone,
                                      // //             inputFormatters: [
                                      // //               LengthLimitingTextInputFormatter(
                                      // //                   10),
                                      // //               FilteringTextInputFormatter
                                      // //                   .digitsOnly,
                                      // //             ],
                                      // //             decoration:
                                      // //                 const InputDecoration(
                                      // //               hintText: "9812345678",
                                      // //               hintStyle: TextStyle(
                                      // //                 fontSize: 35,
                                      // //                 color: Colors.grey,
                                      // //               ),
                                      // //               contentPadding:
                                      // //                   EdgeInsets.only(
                                      // //                       left: 0.0),
                                      // //               border: InputBorder.none,
                                      // //             ),
                                      // //             style: const TextStyle(
                                      // //               fontSize: 35,
                                      // //             ),
                                      // //             onChanged: (value) {
                                      // //               if (value.length == 10) {
                                      // //                 // Close keyboard and focus PAN number textfield when 10 digits are entered
                                      // //                 FocusScope.of(context)
                                      // //                     .requestFocus(
                                      // //                         _panFocusNode);
                                      // //               }
                                      // //             },
                                      // //           ),
                                      // //         ),
                                      // //       ],
                                      // //     ),
                                      // //   ),
                                      // // ),
                                      // Align(
                                      //   //  alignment: Alignment.centerLeft,
                                      //   child: Padding(
                                      //     padding:
                                      //         const EdgeInsets.only(left: 30),
                                      //     child: Row(
                                      //       // crossAxisAlignment: CrossAxisAlignment.center,
                                      //       children: [
                                      //         const Padding(
                                      //           //    padding:  Platform.isIOS ?  EdgeInsets.only(top: 7.0):  EdgeInsets.only(top: 9.0),
                                      //           padding:
                                      //               EdgeInsets.only(top: 7.0),
                                      //           child: Text(
                                      //             "+91 ",
                                      //             style: TextStyle(
                                      //               fontWeight: FontWeight.bold,
                                      //               fontSize: 35,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         Expanded(
                                      //           child:
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "+91 ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 35,
                                                  color: darkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: Platform.isIOS
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 9.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                            fontSize: 35,
                                                            color: darkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          controller:
                                                              controller.mobile,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                10),
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "9812345678",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 35,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 0.0),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: (value) {
                                                            if (value.length ==
                                                                10) {
                                                              // Close keyboard and focus PAN number textfield when 10 digits are entered
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      _panFocusNode);
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    : TextField(
                                                        style: TextStyle(
                                                          fontSize: 35,
                                                          color: darkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        controller:
                                                            controller.mobile,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              10),
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                        ],
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "9812345678",
                                                          hintStyle: TextStyle(
                                                            fontSize: 35,
                                                            color: darkMode
                                                                ? NsdlInvestor360Colors
                                                                    .lightGrey2
                                                                : Colors.grey,
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onChanged: (value) {
                                                          if (value.length ==
                                                              10) {
                                                            // Close keyboard and focus PAN number textfield when 10 digits are entered
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    _panFocusNode);
                                                          }
                                                        },
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30, top: 10),
                                        child: Text(
                                          StringConstants.loginPanText,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: TextField(
                                          style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[A-Z0-9]')),
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          controller: controller.pan,
                                          focusNode: _panFocusNode,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                            hintText: '  Enter PAN number',
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (value.length == 10) {
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Visibility(
                                        visible: false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6),
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                ),
                                                border: Border.all(
                                                  color: NsdlInvestor360Colors
                                                      .lightGrey2,
                                                  width: 1.2,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                children: [
                                                  Transform.scale(
                                                    scale: 1.3,
                                                    child: Checkbox(
                                                      value: true,
                                                      // Change the value as needed
                                                      onChanged: (newValue) {},
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .padded,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'I am human',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                            Color(0xFF696868)),
                                                  ),
                                                  Expanded(
                                                    child:
                                                        Container(), // Empty container to expand space
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/captcha.svg',
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                        const Text(
                                                          'Privacy - Terms',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: Color(
                                                                  0xFF696868)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 22),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),

                                        child: Investor360Button(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            bool shouldSubmit = await controller
                                                .onSubmit(context);
                                            print(
                                                'Should submit: $shouldSubmit');
                                            if (shouldSubmit) {
                                              controller.validatePan(context);
                                            }
                                          },
                                          buttonText: "Login",
                                        ),
                                        // return ElevatedButton(
                                        //   onPressed: () async {
                                        //     FocusScope.of(context).unfocus();

                                        //     bool shouldSubmit =
                                        //         await controller.onSubmit(context);
                                        //     print('Should submit: $shouldSubmit');
                                        //     if (shouldSubmit) {
                                        //       controller.validatePan(context);
                                        //     }
                                        //   },
                                        //   style: ElevatedButton.styleFrom(
                                        //     backgroundColor: NsdlInvestor360Colors
                                        //         .bottomCardHomeColour2,
                                        //     minimumSize:
                                        //         const Size(double.infinity, 50),
                                        //   ),
                                        //   child: controller.isLoading.value
                                        //       ? const CircularProgressIndicator(
                                        //           color: Colors.white,
                                        //         )
                                        //       : Text(
                                        //           "Login",
                                        //           style: TextStyle(
                                        //               fontSize: 20,
                                        //               fontFamily: GoogleFonts.lato()
                                        //                   .fontFamily,
                                        //               color: Colors.white,
                                        //               fontWeight: FontWeight.w400),
                                        //         ),
                                        // );
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Need an Account?  ",
                                            style: TextStyle(
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              controller.launchUrl(context);
                                            },
                                            child: Text(
                                              "Create Now",
                                              style: TextStyle(
                                                  color: NsdlInvestor360Colors
                                                      .appblue,
                                                  fontFamily: GoogleFonts.lato()
                                                      .fontFamily,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 30, right: 30),
                                        child: Text(
                                          StringConstants.loginIntitialText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 50),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: PoweredBy(darkMode
                                              ? Colors.white
                                              : Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //  const SizedBox(height: 10),
                  ]),
                ),
              );
            }
          }),
        ));
  }
}
