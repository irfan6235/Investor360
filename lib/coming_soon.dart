import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import 'package:investor360/widgets/custom_toobar.dart';

import 'modules/portfolio/screens/others.dart';

class Support extends StatefulWidget {
  const Support({super.key, required this.name});
  final String name;
  @override
  State<Support> createState() => SupportState();
}

final _advancedDrawerController = AdvancedDrawerController();

class SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.dashboardScreen.name);
        return false;
      },
      child: AdvancedDrawer(
        //   openScale: 0.8,
        backdrop: Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/drawerAbstract.png'),
              fit: BoxFit.fitWidth,
              //  opacity: 0.1,
              alignment: Alignment.topLeft,
            ),
            gradient: LinearGradient(
              colors: /* darkMode ? [
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
        ),
        backdropColor: Colors.transparent,
        // backdropColor: NsdlInvestor360Colors.drawerColor,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(44)),
          boxShadow: [
            BoxShadow(
              color: NsdlInvestor360Colors.drowShodowDrawerColor,
              //blurStyle: BlurStyle.solid,
              blurRadius: 1.0, // Softness of the shadow
              spreadRadius: -90.0, // Extent of the shadow
              offset: Offset(-140, -10), // Position of the shadow (x, y)
            ),
          ],
        ),
        drawer: CustomDrawer(
          advancedDrawerController: _advancedDrawerController,
        ),
        child: Scaffold(
          backgroundColor: NsdlInvestor360Colors.white,
          appBar: CustomAppBarForScreenName(
            widget.name,
            advancedDrawerController: _advancedDrawerController,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/imagecs2.png')
                  /*SvgPicture.asset(
                  'assets/imagecomingsoon.svg'), // corrected file name
            ),*/
                  ),
              Text(
                textAlign: TextAlign.center,
                "This Page is\nUnder Construction".toString().toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "COMING SOON",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.8,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
