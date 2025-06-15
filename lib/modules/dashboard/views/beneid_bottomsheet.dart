import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';

import '../../../shared/style/colors.dart';
import '../controller/dashboard_controller.dart';

class BottomSheetController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class MyBottomSheet extends StatelessWidget {
  final BottomSheetController controller = Get.put(BottomSheetController());
  final DashboardController controllerDashboard = Get.find();
  var totalValueOnSelection = {}.obs;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomSheetHeight = screenHeight / 1.5;
    bool darkMode = ThemeUtils.isDarkMode(context);
    return DraggableScrollableSheet(
        initialChildSize: 0.4, // Initial height is half the screen
        minChildSize: 0.25, // Minimum height when dragged down
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
                  if (controllerDashboard.responseData.value == null ||
                      controllerDashboard
                              .responseData.value!.dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList =
                      controllerDashboard.responseData.value!.dematAccountList!;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: demartAccountList.length +
                          1, // Add 1 for the "All" item
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: () async {
                              //  await controllerDashboard.fetchNsdlHoldingDataApi();
                              controllerDashboard
                                  .filterHoldingsByDPIDAndClientID(
                                      "ALL", "ALL");
                              // controllerDashboard.displayHoldingDataList.value = controllerDashboard.responseData.value!.holdingDataList!;
                              controllerDashboard
                                  .textEditingControllerBeneid.text = 'All';
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
                                            controller.selectedIndex.value ==
                                                    null
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                        fontSize: 16.1,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        color: controller.selectedIndex.value == null
                                            ? NsdlInvestor360Colors.appMainColor
                                            : darkMode? Colors.white:Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: NsdlInvestor360Colors.lightGrey8,
                                ),
                              ],
                            ),
                          );
                        } else {
                          var holdingData =
                              demartAccountList[index - 1]; // Adjust index
                          return Column(
                            children: [
                              ListTile(
                                subtitle: Text(
                                  "${demartAccountList[index - 1].dpId}- ${demartAccountList[index - 1].clientId}",
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight:
                                        controller.selectedIndex.value == index - 1
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                    color: controller.selectedIndex.value == index - 1
                                        ? NsdlInvestor360Colors.appMainColor
                                        :  darkMode? Colors.white:Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  controllerDashboard.filterHoldingsByDPIDAndClientID(holdingData.dpId!, holdingData.clientId!,);
                                  controller.setSelectedIndex(index - 1);
                                  Get.back(result: {
                                    "dpId_clientId":
                                        "${demartAccountList[index - 1].dpId}- ${demartAccountList[index - 1].clientId}",
                                  });
                                },
                                title: Text(
                                  "${demartAccountList[index - 1].dpName}",
                                  style: TextStyle(
                                    fontSize: 12.0,
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
                                color: NsdlInvestor360Colors.lightGrey8,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 35),
              ],
            ),
          );
        });
  }
}



