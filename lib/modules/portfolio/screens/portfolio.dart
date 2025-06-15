import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/debt.dart';
import 'package:investor360/modules/portfolio/screens/equity.dart';

import 'package:investor360/modules/portfolio/screens/mf.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/formatnumber.dart';
import 'package:investor360/widgets/custom_bottom_navigation.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import 'package:investor360/widgets/custom_toobar.dart';

import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/PortfolioController.dart';
import 'holding_details_screen.dart';
import 'others.dart';

class PortfolioScreen extends StatefulWidget {
  final int selectedPage;
  PortfolioScreen({Key? key, required this.selectedPage}) : super(key: key);
  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends State<PortfolioScreen> {
  late PortfolioController portfolioController;
  late int _selectedIndex;
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    portfolioController = Get.put(PortfolioController());
    _selectedIndex = widget.selectedPage;
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(Routes.dashboardScreen.name);
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
          appBar: CustomAppBarForScreenName(
            "Portfolio",
            advancedDrawerController: _advancedDrawerController,
          ),
          body: Container(
            decoration:  BoxDecoration(
              color:  darkMode ? NsdlInvestor360Colors.darkmodeBlack:  Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: DefaultTabController(
                    initialIndex: _selectedIndex,
                    length: 4,
                    child: Column(
                      children: [
                        TabBar(
                          // physics: NeverScrollableScrollPhysics,
                          isScrollable: false,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.white,
                          indicator: BoxDecoration(
                            color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.bottomCardHomeColour1,// Indicator color
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color:  darkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 8, right: 8),
                                child: Text(
                                  "Equity",
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
                                    top: 4, bottom: 4, left: 12, right: 12),
                                child: Text(
                                  "MF       ",
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
                                    top: 4, bottom: 4, left: 12, right: 12),
                                child: Text(
                                  "Debt   ",
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
                                    top: 4, bottom: 4, left: 4, right: 4),
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
                            _unfocusKeyboard();

                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                        const Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Equity(),
                              MfScreen(),
                              Debt(),
                              Others(),
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
            currentIndex: 1,
            onTap: (index) {
              _unfocusKeyboard();
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

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }
}

class CommonTabContent extends StatelessWidget {
  final Widget child;
  const CommonTabContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "MARKET VALUE",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.8,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: NsdlInvestor360Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatNumber(128000.00),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 34,
                    fontFamily: GoogleFonts.lato().fontFamily,
                    color: Colors.black,
                  ),
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/refreshbutton.png'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          child,
        ]),
      ),
    );
  }
}

class HoldingsContent extends StatelessWidget {
  const HoldingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: NsdlInvestor360Colors.backLightBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Sort",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  Image.asset('assets/sort.png'),
                  const Spacer(),
                  Image.asset('assets/arrows.png'),
                  const SizedBox(width: 5),
                  const Text("Current (Invested)")
                ],
              ),
              const SizedBox(height: 50),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Infosys Ltd',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Qty. 10500',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/graph.png',
                        width: 50,
                        height: 24,
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '\u20B9 10,98,345',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '(10,93,610)',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
