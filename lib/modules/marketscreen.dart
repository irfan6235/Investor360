import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import '../routes/routes.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../widgets/custom_toobar.dart';

class MarketScreen extends StatelessWidget {
  MarketScreen({super.key});
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {

    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(Routes.dashboardScreen.name);
        return false;
      },
      child: AdvancedDrawer(
        backdrop: Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/drawerAbstract.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topLeft,
            ),
            gradient: LinearGradient(
              colors:  /*darkMode ? [
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
              blurRadius: 1.0,
              spreadRadius: -90.0,
              offset: Offset(-140, -10),
            ),
          ],
        ),
        drawer: CustomDrawer(
          advancedDrawerController: _advancedDrawerController,
        ),
        child: Scaffold(
          backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          appBar: CustomAppBarForScreenName(
            "Market",
            advancedDrawerController: _advancedDrawerController,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(darkMode ? 'assets/maintenance.png' :'assets/imagecs2.png' , scale: darkMode ? 1.6:1),
              ),
              SizedBox(height: 10,),
              Text(
                "This Page is\nUnder Construction".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: GoogleFonts.roboto().fontFamily,

                ),
              ),
              SizedBox(height: 14),
              Text(
                "COMING SOON",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.8,
                  fontFamily: GoogleFonts.roboto().fontFamily,

                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 3,
            onTap: (index) {
              switch (index) {
                case 0:
                  Get.toNamed(Routes.dashboardScreen.name);
                  break;
                case 1:
                  Get.toNamed(Routes.portfolio.name);
                  break;
                case 2:
                  Get.toNamed(Routes.account.name);
                  break;
                case 3:
                  Get.toNamed(Routes.market.name);
                  break;
                case 4:
                  Get.toNamed(Routes.services.name);
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
