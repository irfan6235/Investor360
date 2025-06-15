import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/login/controller/otp_screen_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../routes/routes.dart';
import '../../../shared/style/colors.dart';
import '../../../widgets/powered_by.dart';

class LoginOtpScreen extends StatefulWidget {
  LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final controller = Get.put(OtpScreenController());
  final isLandscape =
      MediaQuery.of(Get.context!).orientation == Orientation.landscape;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        bool didNavigate = await controller.navigateToLogin();
        controller.timer.cancel();
        return didNavigate;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {
                                controller.hasError.value = false;
                                controller.resetTimer();
                                controller.pin.clear();
                                Get.toNamed(Routes.loginScreen.name);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: NsdlInvestor360Colors.appMainColor,
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
                            child:
                                CountdownTimerWidget(seconds: controller.start),
                          ),
                        ),
                        const SizedBox(height: 20),
                         Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            "Please enter the OTP sent on your phone number",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 25,color: darkMode ? Colors.white : Colors.black,),
                          ),
                        ),
                        const SizedBox(height: 20),
                         Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Verification code",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16,color: darkMode ? Colors.white : Colors.black,),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: PinCodeTextField(
                            keyboardType: TextInputType.number,
                            controller: controller.pin,
                            appContext: context,
                            length: 6,
                            onChanged: (value) {
                              controller.hasError.value = false;
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              inactiveColor: controller.hasError.value
                                  ? Colors.red
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle:  TextStyle(color: darkMode ? Colors.white : Colors.black,),
                            inputFormatters: [
                              OnlyDigitsInputFormatter(),
                            ],
                            beforeTextPaste: (text) {
                              return false; // Disable pasting
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Investor360Button(
                            buttonText: "Validate",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              controller.validateOTPField(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Visibility(
                            visible: controller.isInputDisabled.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                  "Did not receive OTP?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,color: darkMode ? Colors.white : Colors.grey,),
                                ),
                                const SizedBox(width: 3),
                                TextButton(
                                  onPressed: () {
                                    controller.ResendOtpAPI();
                                  },
                                  child: const Text(
                                    "Resend",
                                    style: TextStyle(
                                        color:
                                            NsdlInvestor360Colors.appMainColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PoweredBy( darkMode ? Colors.white : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CountdownTimerWidget extends StatelessWidget {
  final RxInt seconds;

  const CountdownTimerWidget({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Obx(() {
      final minutes = seconds.value ~/ 60;
      final remainingSeconds = seconds.value % 60;
      return Text(
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')}',
        style:  TextStyle(
          color: darkMode ? NsdlInvestor360Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      );
    });
  }
}
