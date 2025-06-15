import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/coming_soon.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/drawer/controller/drawer_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';

class CustomDrawer extends StatelessWidget {
  final CustomDrawerController controller = Get.put(CustomDrawerController());
  final AdvancedDrawerController advancedDrawerController;

  CustomDrawer({required this.advancedDrawerController}) {
    controller.setDrawerController(advancedDrawerController);
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    Widget buildListTile({
      required int index,
      required String asset,
      required String title,
      required Function() onTap,
    }) {
      return Obx(() {
        final isSelected = controller.selectedIndex.value == index;
        final isProfileSelected = controller.selectedIndex.value == 0;
        final textStyle = TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: isSelected ? 18 : 16,
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isProfileSelected && isSelected
              ? FontWeight.bold
              : FontWeight.normal,
        );

        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: Container(
            color: Colors.transparent,
            child: ListTile(
              leading: SvgPicture.asset(asset),
              title: Text(
                title,
                style: textStyle,
              ),
              onTap: () {
                controller.navigateToIndex(index);
                onTap();
              },
            ),
          ),
        );
      });
    }

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: 70, // Adjust width to fit the rounded container
                        height: 70, // Adjust height to fit the rounded container
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60), // Makes the container circular
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/usernew.png',
                            height: 100,
                          ),
                          /*SvgPicture.asset(
                            'assets/userimg.svg',
                          ),*/
                        ),
                      ),
                    ),
                   /* Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        'assets/userimg.png',
                        scale: 1.9,
                      ),
                    ),*/
                    const SizedBox(width: 5),
                    Obx(() {
                      final name =
                          dashboardController.responseData.value?.name ?? '';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 19.4,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 13),
                Visibility(
                  visible: false,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Demat Account",
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.4,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.4,
                              ),
                            ),
                            hintText: "All",
                            hintStyle: TextStyle(
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                buildListTile(
                  index: 0,
                  asset: 'assets/profile_drawer.svg',
                  title: 'Profile',
                  onTap: () {
                    controller.navigateToIndex(0);
                  },
                ),
                buildListTile(
                  index: 1,
                  asset: 'assets/portfolio_drawer.svg',
                  title: 'Portfolio',
                  onTap: () {
                    controller.navigateToIndex(1);
                  },
                ),
                buildListTile(
                  index: 2,
                  asset: 'assets/services_drawer.svg',
                  title: 'Services',
                  onTap: () {
                    controller.navigateToIndex(2);
                  },
                ),
                buildListTile(
                  index: 3,
                  asset: 'assets/change_drawer.svg',
                  title: 'Change M-PIN',
                  onTap: () {
                    controller.navigateToIndex(3);
                  },
                ),
                buildListTile(
                  index: 4,
                  asset: 'assets/termsuse.svg',
                  title: 'Terms of use',
                  onTap: () {
                    controller.navigateToIndex(4);
                  },
                ),
                buildListTile(
                  index: 5,
                  asset: 'assets/invite_drawer.svg',
                  title: 'Invite',
                  onTap: () {
                    controller.navigateToIndex(5);
                  },
                ),
                buildListTile(
                  index: 6,
                  asset: 'assets/faq.svg',
                  title: 'Support',
                  onTap: () {
                    controller.navigateToIndex(6);
                  },
                ),
                const SizedBox(height: 10),
                const Divider(
                    indent: 10,
                    endIndent: 10,
                    color: NsdlInvestor360Colors.lightGrey8),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: buildListTile(
                    index: 7,
                    asset: 'assets/logout_drawer.svg',
                    title: 'Logout',
                    onTap: () async {
                     dashboardController.logoutApi();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
