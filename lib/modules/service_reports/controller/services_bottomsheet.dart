import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';

import '../../../shared/style/colors.dart';

class BottomSheetServicesCustomController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class ServicesCustomBottomSheet extends StatelessWidget {
  final BottomSheetServicesCustomController controller = Get.put(BottomSheetServicesCustomController());
 // final DashboardController dashboardController = Get.find();
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.dematAccountList != null &&
        dashboardController.responseData.value!.dematAccountList!.isNotEmpty) {
      var firstAccount = dashboardController.responseData.value!.dematAccountList!.first;
      //dashboardController.filterHoldingsByDPIDAndClientID(firstAccount.dpId!, firstAccount.clientId!);
      controller.setSelectedIndex(0);
    }

    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.25,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                  if (dashboardController.responseData.value == null ||
                      dashboardController.responseData.value!.dematAccountList == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = dashboardController.responseData.value!.dematAccountList!;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: demartAccountList.length,
                      itemBuilder: (context, index) {
                        var holdingData = demartAccountList[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                style: TextStyle(
                                  fontWeight: controller.selectedIndex.value == index ? FontWeight.bold : FontWeight.w500,
                                  color: controller.selectedIndex.value == index ? NsdlInvestor360Colors.appMainColor : Colors.black,
                                ),
                              ),
                              onTap: () {
                                dashboardController.filterHoldingsByDPIDAndClientID(holdingData.dpId!, holdingData.clientId!);
                                controller.setSelectedIndex(index);
                                Get.back(result: {
                                  "dpId_clientId": "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                  "dpId": "${demartAccountList[index].dpId}",
                                  "clientId": "${demartAccountList[index].clientId}",
                                });
                              },
                            ),
                            const Divider(
                              indent: 10,
                              endIndent: 10,
                              color: NsdlInvestor360Colors.lightGrey8,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }),
                // Example of using TextField in Obx with constraints
               /* Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter text',
                          ),
                        ),
                      ),
                    ],
                  );
                }),*/
              ],
            ),
          );
        }
    );
  }
}
