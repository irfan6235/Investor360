import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/dashboard/controller/dashboard_controller.dart';
import '../routes/routes.dart';
import '../utils/string_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // const CustomAppBar({super.key});
  final AdvancedDrawerController advancedDrawerController;

  const CustomAppBar({Key? key, required this.advancedDrawerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    bool darkMode = ThemeUtils.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        margin: const EdgeInsets.only(left: 0.0),
        child: AppBar(
          backgroundColor: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          elevation: 0, // Remove the shadow

          leading: GestureDetector(
            onTap: () {
              advancedDrawerController.showDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: const CircleAvatar(
                  backgroundColor: NsdlInvestor360Colors.lightestGrey,
                  radius: 20,
                  backgroundImage: AssetImage('assets/usernew.png'),
                ),
              ),
            ),
          ),
          title: Container(
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hello",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.2,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    color: Colors.grey.shade600,
                  ),
                ),
                Obx(() {
                  final name =
                      dashboardController.responseData.value?.name ?? '';
                  return Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  );
                }),
              ],
            ),
            /*   decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 22,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: NsdlInvestor360Colors.grey,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by fund name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),*/
          ),
          actions: [
            Visibility(
              visible: false,
              child: SvgPicture.asset(
                'assets/qrbtn_img.svg',
              ),
            ),
            /* IconButton(
              icon: const Icon(Icons.qr_code_rounded),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setBool(KeyConstants.isLoggedIn, false);
                Get.toNamed(Routes.loginScreen.name);
              },
            ),*/
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarForScreenName extends StatelessWidget
    implements PreferredSizeWidget {
  String screenName;
  final AdvancedDrawerController advancedDrawerController;

  CustomAppBarForScreenName(this.screenName,
      {super.key, required this.advancedDrawerController});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return AppBar(
      backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
      elevation: 0.5,
      shadowColor: Colors.white.withOpacity(0.6),
      leading: GestureDetector(
        onTap: () {
          advancedDrawerController.showDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            margin: const EdgeInsets.only(left: 12.0),
            child: const CircleAvatar(
              backgroundColor: NsdlInvestor360Colors.lightestGrey,
              radius: 20,
              backgroundImage: AssetImage('assets/usernew.png'),
            ),
          ),
        ),
      ),
      title: Center(
          child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Text(
          screenName,
          style: TextStyle(
              fontSize: 19,
              fontFamily: GoogleFonts.roboto().fontFamily,
              color:  darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      )),
      actions: [
        Visibility(
          visible: false,
          child: IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool(KeyConstants.isLoggedIn, false);
              Get.toNamed(Routes.loginScreen.name);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
