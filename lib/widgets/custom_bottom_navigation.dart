import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/drawer/controller/drawer_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  final CustomDrawerController customDrawerController =
      Get.put(CustomDrawerController());

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _onItemTapped(int index) {
    customDrawerController.resetDrawerState();
    switch (index) {
      case 0:
        Get.toNamed('/dashboardScreen');
        break;
      case 1:
        Get.toNamed('/portfolio');
        break;
      case 2:
        Get.toNamed('/account');
        break;
      case 3:
        Get.toNamed('/market');
        break;
      case 4:
        Get.toNamed('/services');
        break;
    }
    Vibrate.feedback(FeedbackType.light);
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
              bodySmall: const TextStyle(color: NsdlInvestor360Colors.grey),
            ),
      ),
      child: BottomNavigationBar(
        elevation: 50,
        useLegacyColorScheme: true,
        backgroundColor: darkMode
            ? NsdlInvestor360Colors.darkmodeBlackbottomnav
            : NsdlInvestor360Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: darkMode
                  ? SvgPicture.asset(
                      currentIndex == 0
                          ? 'assets/dashboard_selected.svg'
                          : 'assets/dashboard_unselected.svg',
                      width: 20,
                      height: 20,
                      color: Colors.white60,
                    )
                  : SvgPicture.asset(
                      currentIndex == 0
                          ? 'assets/dashboard_selected.svg'
                          : 'assets/dashboard_unselected.svg',
                      width: 20,
                      height: 20,
                    ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: darkMode
                  ? SvgPicture.asset(
                      currentIndex == 1
                          ? 'assets/portfolio_selected.svg'
                          : 'assets/portfolio_unselected.svg',
                      width: 20,
                      height: 20,
                color: Colors.white60,
                    )
                  : SvgPicture.asset(
                      currentIndex == 1
                          ? 'assets/portfolio_selected.svg'
                          : 'assets/portfolio_unselected.svg',
                      width: 20,
                      height: 20,
                    ),
            ),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child:

              darkMode
                  ? SvgPicture.asset(
                currentIndex == 2
                    ? 'assets/account_selected.svg'
                    : 'assets/account.svg',
                width: 20,
                height: 20,
                color: Colors.white60,
              )
                  :
              SvgPicture.asset(
                currentIndex == 2
                    ? 'assets/account_selected.svg'
                    : 'assets/account.svg',
                width: 20,
                height: 20,
              ),
            ),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child:

              darkMode
                  ? SvgPicture.asset(
                currentIndex == 3
                    ? 'assets/market_selected.svg'
                    : 'assets/market_unselected.svg',
                width: 20,
                height: 20,
                color: Colors.white60,
              )
                  :
              SvgPicture.asset(
                currentIndex == 3
                    ? 'assets/market_selected.svg'
                    : 'assets/market_unselected.svg',
                width: 20,
                height: 20,
              ),
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child:
              darkMode
                  ? SvgPicture.asset(
                currentIndex == 4
                    ? 'assets/more_selected2.svg'
                    : 'assets/more_unselected.svg',
                width: 20,
                height: 20,
                color: Colors.white60,
              )
                  :
              SvgPicture.asset(
                currentIndex == 4
                    ? 'assets/more_selected2.svg'
                    : 'assets/more_unselected.svg',
                width: 20,
                height: 20,
              ),
            ),
            label: 'More',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: darkMode
            ? Colors.white60
            : NsdlInvestor360Colors.bottomCardHomeColourLighter,
        unselectedItemColor: NsdlInvestor360Colors.grey,
        selectedLabelStyle: TextStyle(
          color: NsdlInvestor360Colors.bottomCardHomeColourLighter,
          fontWeight: FontWeight.w800,
          fontSize: 11.6,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          color: NsdlInvestor360Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 11.0,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }
}
