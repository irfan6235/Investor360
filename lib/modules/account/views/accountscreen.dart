import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/widgets/custom_bottom_navigation.dart';
import 'package:investor360/widgets/custom_toobar.dart';
import '../controller/account_controller.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _advancedDrawerController = AdvancedDrawerController();
  final AccountController controller = Get.put(AccountController());
  int? _currentlyExpandedIndex;
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
                colors: /*darkMode ? [
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
            backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
            appBar: CustomAppBarForScreenName(
              "Account",
              advancedDrawerController: _advancedDrawerController,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: SizedBox());
              } else if (controller.dashboardController.responseData.value !=
                  null) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "PERSONAL DETAILS",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            color: NsdlInvestor360Colors.lightestgrey3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontWeight: FontWeight.w400,
                              color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            controller.dashboardController.responseData.value
                                    ?.name
                                    .toString() ??
                                "Hello",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: darkMode ? Colors.white : Colors.black,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Mobile Number",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontWeight: FontWeight.w400,
                              color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return Text(
                                  controller.isMobileVisible.value
                                      ? controller.mobileNumber.value
                                      : controller.mobile.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: darkMode ? Colors.white : Colors.black,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: () {
                                  controller.toggleMobileVisibility();
                                  controller.isHiddenM.value =
                                      !controller.isHiddenM.value;
                                },
                                child: Obx(() {
                                  return controller.isHiddenM.value
                                      ? SvgPicture.asset('assets/eye.svg', color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,)
                                      : SvgPicture.asset(
                                          'assets/eye-slash-hidden.svg',
                                    color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "PAN Number",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontWeight: FontWeight.w400,
                              color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return Text(
                                  controller.isPanVisible.value
                                      ? controller.panNo.value
                                      : controller.pan.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: darkMode ? Colors.white : Colors.black,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: () {
                                  controller.togglePanVisibility();
                                  controller.isHiddenP.value =
                                      !controller.isHiddenP.value;
                                },
                                child: Obx(() {
                                  return controller.isHiddenP.value
                                      ? SvgPicture.asset('assets/eye.svg', color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,)
                                      : SvgPicture.asset(
                                          'assets/eye-slash-hidden.svg',
                                    color: darkMode? Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          //   color: NsdlInvestor360Colors.backLightBlue,
                          padding: const EdgeInsets.all(14.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    AccountBottomSheet(),
                                    isScrollControlled: true,
                                    enterBottomSheetDuration:
                                        const Duration(milliseconds: 100),
                                    exitBottomSheetDuration:
                                        const Duration(milliseconds: 100),
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        controller.dpId_clientId.value =
                                            value["dpId_clientId"];
                                        controller
                                            .textEditingControllerBeneidAccount
                                            .text = value[
                                                "dpId_clientId"] ??
                                            "";
                                        print('Selected: $value');
                                      });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 2),
                                  child: SizedBox(
                                    height: 50,
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextField(
                                        controller: controller
                                            .textEditingControllerBeneidAccount,
                                        decoration: InputDecoration(
                                          labelText: "Demat Account",
                                          labelStyle:  TextStyle(
                                            color: darkMode ? Colors.grey : NsdlInvestor360Colors.black,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: NsdlInvestor360Colors
                                                  .lightGrey7,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: NsdlInvestor360Colors
                                                  .lightGrey7,
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: NsdlInvestor360Colors
                                                  .lightGrey7,
                                              width: 1.0,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: NsdlInvestor360Colors
                                                  .lightGrey7,
                                              width: 1.0,
                                            ),
                                          ),
                                          hintText: "All",
                                          hintStyle: TextStyle(
                                            fontFamily:
                                                GoogleFonts.roboto().fontFamily,
                                            fontSize: 18,
                                            color: darkMode ? Colors.white : NsdlInvestor360Colors.textColour,
                                          ),
                                          suffixIcon:  Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                          ),
                                        ),
                                        style:  TextStyle(
                                          color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value.emailId ??
                                    "-",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                    color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Address",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value.address ??
                                    "-",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Bank account DETAILS".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                color: NsdlInvestor360Colors.lightestgrey3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Bank Name",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value.bankName ??
                                    "Other Bank",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "IFSC Code",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value.bankIFSC ??
                                    "--",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value
                                        .bankAccountNumber ??
                                    "*********1234",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                color: NsdlInvestor360Colors.lightestgrey3,
                              ),
                            ),
                            const SizedBox(height: 13),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Account Status",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.accountDematList.value
                                        .statusDescription ??
                                    "-",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "NOMINEE DETAILS",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                color: NsdlInvestor360Colors.lightestgrey3
                                    .withOpacity(0.8),
                              ),
                            ),
                            //      const SizedBox(height: 20),

                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller
                                  .accountDematList.value.nomineeList!.length,
                              itemBuilder: (context, index) {
                                final item = controller
                                    .accountDematList.value.nomineeList![index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16),
                                  child: ExpansionTile(
                                    collapsedIconColor: darkMode ? Colors.white:Colors.black,
                                    key: Key(index.toString()),
                                    backgroundColor:  darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.backLightBlue,
                                    iconColor:  darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    title: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.album_rounded,
                                          size: 8.5,
                                          color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                        ),
                                        SizedBox(width: 4.4),
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            fontFamily: GoogleFonts.lato().fontFamily,
                                            color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onExpansionChanged: (bool expanded) {
                                      setState(() {
                                        _currentlyExpandedIndex =
                                            expanded ? index : null;
                                      });
                                    },
                                    initiallyExpanded:
                                        _currentlyExpandedIndex == index,
                                    children: <Widget>[
                                      _buildTileSection(
                                          "Nominee Name", item.name, false),
                                      // const SizedBox(height: 10),
                                      // Obx(() {
                                      //   return _buildTileSection(
                                      //     "PAN",
                                      //     controller.isHiddeNominePList[index]
                                      //             .value
                                      //         ? item.pan
                                      //         : controller.obscureMobileNumber(
                                      //             item.pan),
                                      //     true,
                                      //     index,
                                      //   );
                                      // }),
                                      const SizedBox(height: 10),
                                      _buildTileSection("Share Percentage",
                                          item.sharePercentage + "%", false),
                                      const SizedBox(height: 20),
                                    ],
                                  ).applyTheme(
                                      NsdlInvestor360Colors.lightestgrey3),
                                );
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text("Please Wait Until Personal Details Loads"));
              }
            }),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: 2,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Get.toNamed(Routes.dashboardScreen.name);
                    Get.delete<AccountController>();
                    break;
                  case 1:
                    Get.toNamed(Routes.portfolio.name);
                    Get.delete<AccountController>();
                    break;
                  case 2:
                    Get.toNamed(Routes.account.name);
                    Get.delete<AccountController>();
                    break;
                  case 3:
                    Get.toNamed(Routes.market.name);
                    Get.delete<AccountController>();
                    break;
                  case 4:
                    Get.toNamed(Routes.services.name);
                    Get.delete<AccountController>();
                    break;
                }
              },
            ),
          ),
        ));
  }

  Widget _buildTileSection(String title, String content, bool eye,
      [int? index]) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.6,
              fontFamily: GoogleFonts.lato().fontFamily,
              fontWeight: FontWeight.w400,
              color: darkMode ? Colors.grey : NsdlInvestor360Colors.textColour,
            ),
          ),
          // if (eye)
          //   GestureDetector(
          //     onTap: () {
          //       if (index != null) {
          //         controller.toggleNoomineePanVisibility(index);
          //       }
          //     },
          //     child: Obx(() {
          //       return index != null &&
          //               controller.isHiddeNominePList[index].value
          //           ? SvgPicture.asset('assets/eye.svg')
          //           : SvgPicture.asset('assets/eye-slash-hidden.svg');
          //     }),
          //   ),
          Text(
            content,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: GoogleFonts.lato().fontFamily,
              color: darkMode ? Colors.white : NsdlInvestor360Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
