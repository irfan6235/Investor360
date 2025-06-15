import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/splash/controller/splash_screen_controller.dart';
import 'package:investor360/widgets/powered_by.dart';

import '../../../shared/style/colors.dart';

class SplashScreen extends StatelessWidget {
  final controller = Get.put(SplashScreenController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration:  const BoxDecoration(
             // color: Color(0xFF2958FF),
              gradient: LinearGradient(
                colors:  /* darkMode ? [
                  NsdlInvestor360Colors.bottomCardHomeColour2Dark,
                  NsdlInvestor360Colors.bottomCardHomeColour0,
                ] :*/
                [
                  NsdlInvestor360Colors.bottomCardHomeColour2,
                  NsdlInvestor360Colors.bottomCardHomeColour0,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/Abstract.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(child: Image.asset('assets/logo.png')),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:  PoweredBy(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
