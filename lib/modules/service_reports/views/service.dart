import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/views/report.dart';
import 'package:investor360/modules/service_reports/views/serviceOthers.dart';
import 'package:investor360/modules/service_reports/views/transact.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/widgets/custom_bottom_navigation.dart';
import 'package:investor360/widgets/custom_toobar.dart';

class Service extends StatefulWidget {
  final int selectedPage;

  Service({super.key, required this.selectedPage});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  final _advancedDrawerController = AdvancedDrawerController();

  late int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    _selectedIndex = widget.selectedPage;

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
          backgroundColor: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          appBar: CustomAppBarForScreenName(
            "Services",
            // "Reports",
            advancedDrawerController: _advancedDrawerController,
          ),
          body: Container(
            decoration:  BoxDecoration(
              color: darkMode ? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.pureWhite,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: DefaultTabController(
                    initialIndex: _selectedIndex,
                    length: 3,
                    child: Column(
                      children: [
                        Visibility(
                          visible: true,
                          child: TabBar(
                            // physics: NeverScrollableScrollPhysics,
                            isScrollable: false,
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.white,
                            indicator: BoxDecoration(
                              color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.bottomCardHomeColour1,// Indicator color
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0,
                                      3), // Offset by 3 vertically for bottom shadow
                                ),
                              ],
                            ),
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: Text(
                                    "Reports",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 15, right: 15),
                                  child: Text(
                                    "Transact",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: Text(
                                    "Others",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        ),
                        const Expanded(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              SingleChildScrollView(child: Report()),
                              SingleChildScrollView(child: Transact()),
                              SingleChildScrollView(child: ServiceOthers()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 4,
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
