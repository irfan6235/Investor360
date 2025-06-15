import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/controller/PortfolioController.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';

import '../../../shared/style/colors.dart';

class BottomSheetPortfolioController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }
}

class MyBottomSheetPortfolio extends StatelessWidget {
  final BottomSheetPortfolioController controller =
      Get.put(BottomSheetPortfolioController());
  final PortfolioController portfolioController = Get.find();
  String securityType;

  MyBottomSheetPortfolio(this.securityType);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomSheetHeight = screenHeight / 1.5;
    bool darkMode = ThemeUtils.isDarkMode(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.25,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
            color: darkMode? NsdlInvestor360Colors.darkmodeBlack: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Demat Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.6,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ),
              Obx(() {
                if (portfolioController.responseData.value == null ||
                    portfolioController.responseData.value!.dematAccountList ==
                        null) {
                  return const Center(child: CircularProgressIndicator());
                }

                var demartAccountList =
                    portfolioController.responseData.value!.dematAccountList!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: demartAccountList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: () async {
                            //   await portfolioController.fetchNsdlHoldingDataApiPortfolio();
                            portfolioController.filterHoldingsByDPIDAndClientID(
                                "ALL", "ALL", securityType);
                            updatePortfolioController(securityType);
                            //  portfolioController.filterHoldingsByDPIDAndClientID("", "", securityType);
                            controller.resetSelection();
                            Get.back();
                          },
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 7, bottom: 7),
                                  child: Text(
                                    "All",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight:
                                          controller.selectedIndex.value == null
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                      fontSize: 16.1,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: controller.selectedIndex.value ==
                                              null
                                          ? NsdlInvestor360Colors.appMainColor
                                          : darkMode? Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: NsdlInvestor360Colors.lightGrey8),
                            ],
                          ),
                        );
                      } else {
                        var holdingData = demartAccountList[index - 1];
                        return Column(
                          children: [
                            ListTile(
                              subtitle: Text(
                                "${holdingData.dpId}- ${holdingData.clientId}",
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: controller.selectedIndex.value ==
                                          index - 1
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: controller.selectedIndex.value ==
                                          index - 1
                                      ? NsdlInvestor360Colors.appMainColor
                                      : darkMode? Colors.white:Colors.black,
                                ),
                              ),
                              onTap: () {
                                portfolioController
                                    .filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                  securityType,
                                );
                                controller.selectedIndex.value = index - 1;
                                var selectedData = {
                                  "dpId_clientId":
                                      "${holdingData.dpId}- ${holdingData.clientId}",
                                };
                                Get.back(result: selectedData);
                              },
                              title: Text(
                                "${demartAccountList[index - 1].dpName}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  controller.selectedIndex.value == index - 1
                                      ? FontWeight.w500
                                      : FontWeight.w500,
                                  color: controller.selectedIndex.value == index - 1
                                      ? NsdlInvestor360Colors.appMainColor
                                      :  darkMode? Colors.white60:Colors.grey[600],
                                ),
                              ),
                            ),
                            const Divider(
                                indent: 10,
                                endIndent: 10,
                                color: NsdlInvestor360Colors.lightGrey8),
                          ],
                        );
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void updatePortfolioController(String securityType) {
    switch (securityType) {
      case "EQUITY":
        portfolioController.textEditingControllerBeneidEquity.text = 'All';
        // controller.selectedIndex.value = null;
        break;
      case "MUTUAL_FUNDS":
        portfolioController.textEditingControllerBeneidMF.text = 'All';
      //controller.selectedIndex.value = null;
      case "DEBT":
        portfolioController.textEditingControllerBeneidDebt.text = 'All';
      //controller.selectedIndex.value = null;
      case "OTH":
        portfolioController.textEditingControllerBeneidOthers.text = 'All';
        // controller.selectedIndex.value = null; // Reset the selection
        break;
      default:
        break;
    }
  }
}






