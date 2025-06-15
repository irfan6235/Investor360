import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/login/controller/login_pan_controller.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/utils/text_formatter.dart';

class LoginPanScreen extends StatelessWidget {
  final LoginPanController controller = Get.put(LoginPanController());

  LoginPanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2958FF),
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
                        padding: const EdgeInsets.only(top: 70, left: 30),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 50,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 30),
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 30, left: 30),
                                child: Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      "+91 ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    return Text(
                                      controller.mobileNumber.value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  UpperCaseTextFormatter() // Add this line to automatically convert text to uppercase
                                ],
                                controller: controller.pan,
                                decoration: const InputDecoration(
                                  hintText: '  Enter PAN number ',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: Text(
                                StringConstants.loginPanText,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Color(0xFF7B7B7B)),
                              ),
                            ),
                            const SizedBox(height: 60),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Obx(() {
                                return ElevatedButton(
                                  onPressed: () {
                                    controller.validatePan(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2958FF),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        ) // Show circular progress indicator when isLoading is true
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                );
                              }),
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
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/powered_by_grey.png')),
          ),
        ],
      ),
    );
  }
}
