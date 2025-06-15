import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/services_transact/data/service_transact_repo.dart';
import 'package:investor360/modules/services_transact/model/deleteNonNsdlBeneRequest.dart';
import 'package:investor360/modules/services_transact/model/deleteNsdlBeneficiaryRequest.dart';
import 'package:investor360/modules/services_transact/model/getBeneficiariesRequest.dart';
import 'package:investor360/modules/services_transact/model/getBeneficiaryResponse.dart';
import 'package:investor360/modules/services_transact/views/bottomsheet_add_bene.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryDetailsController extends GetxController {
  final ServiceTransactRepo serviceTransactRepo = ServiceTransactRepo();
  final DashboardController dashboardController =
      Get.put(DashboardController());
  TextEditingController textEditingControllerBeneidViewBene =
      TextEditingController();
  var isLoading = true.obs;
  var beneficiaries = <GetBeneficiaryResponse>[].obs;
  var selectedClientId = "".obs;
  var selectedDpId = "".obs;
  var dpId_clientId = ''.obs;
  bool isSpecificPageActive = false;
  bool isDeleteVisible = true;

  @override
  void onInit() {
    // initializeData();
    super.onInit();
  }

  void getBeneficiaryApi(String dpId, String clientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      print("Session ID is missing in SharedPreferences");
      isLoading.value = false;
      return;
    }

    GetBeneficiariesRequest beneficiariesRequest = GetBeneficiariesRequest(
      dpId: dpId,
      clientId: clientId,
      sessionData: SessionData(sessionId: sessionId),
    );

    try {
      isLoading.value = true; // Set loading to true before the API call
      var res =
          await serviceTransactRepo.getBeneficiaries(beneficiariesRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        print("API Running Success");
        print("Get Beneficiaries API has hit");
        var body = res.data;
        if (body != null && body is List) {
          beneficiaries.value =
              body.map((e) => GetBeneficiaryResponse.fromJson(e)).toList();
        } else {
          beneficiaries.value = [];
        }
      } else {
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data');
    } finally {
      isLoading.value = false; // Set loading to false after the API call
    }
  }

  void initializeData() async {
    await setInitialDpIdAndClientId();
    if (selectedDpId.value.isNotEmpty && selectedClientId.value.isNotEmpty) {
      getBeneficiaryApi(
          selectedDpId.value.toString(), selectedClientId.value.toString());
    }
  }

  Future<void> setInitialDpIdAndClientId() async {
    if (dashboardController.responseData.value != null) {
      var dematAccountList =
          dashboardController.responseData.value!.dematAccountList;
      if (dematAccountList != null) {
        // Update the state after the current frame is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectedDpId.value = dematAccountList[0].dpId ?? "";
          selectedClientId.value =
              dematAccountList[0].clientId.toString() ?? "";
          textEditingControllerBeneidViewBene.text =
              "${selectedDpId.value}-${selectedClientId.value}";
        });
      }
    }
  }

  void filterHoldingsByDPIDAndClientID(var dpId, var clientId) {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.holdingDataList != null) {
      if (dpId == "ALL") {
        selectedClientId.value = "ALL";
      } else if (dpId == null || clientId == null) {
        selectedClientId.value = "";
      } else {}
    }
  }

  void deleteNsdlBeneficiaryAPI(
      String dpId, String clientId, String pan, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      print("Session ID is missing in SharedPreferences");
      isLoading.value = false;
      return null;
    }

    DelNsdlBeneficiary delnsdlBeneficiary = DelNsdlBeneficiary(
      srcDpId: selectedDpId.value.toString(),
      srcClientId: selectedClientId.value.toString(),
      dpId: dpId,
      clientId: clientId,
      pan: pan,
    );

    DelSessionData sessionData = DelSessionData(
      sessionId: sessionId,
    );

    DeleteNsdlBeneficiaryRequest deleteNSdlBeneficiariesRequest =
        DeleteNsdlBeneficiaryRequest(
      nsdlBeneficiary: delnsdlBeneficiary,
      sessionData: sessionData,
    );

    try {
      var res = await serviceTransactRepo
          .deleteNsdlBeneficiary(deleteNSdlBeneficiariesRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        // Get.back();
        Get.bottomSheet(AddBeneBottomSheetVerify(called: "Delete"));

        print("API Running Success");
        print("Delete NSDL Beneficiary API has hit");
      } else {
        Get.back();
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      Get.back();
      print("#Exception: $e");
      throw Exception('Failed to load data');
    } finally {
      // isLoading.value = false;
    }
  }

  void deleteNonNsdlBeneficiaryAPI(
      String dematAccountt, String pan, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      print("Session ID is missing in SharedPreferences");
      isLoading.value = false;
      return null;
    }

    DelNonNsdlBeneficiary delnonnsdlBeneficiary = DelNonNsdlBeneficiary(
      srcDpId: selectedDpId.value.toString(),
      srcClientId: selectedClientId.value.toString(),
      dematAccount: dematAccountt,
      pan: pan,
    );

    DelNonSessionData sessionData = DelNonSessionData(
      sessionId: sessionId,
    );

    DeleteNonNsdlBeneficiaryRequest deleteNonNSdlBeneficiariesRequest =
        DeleteNonNsdlBeneficiaryRequest(
      nonNsdlBeneficiary: delnonnsdlBeneficiary,
      sessionData: sessionData,
    );

    try {
      var res = await serviceTransactRepo
          .deleteNonNsdlBeneficiary(deleteNonNSdlBeneficiariesRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        // Get.back();
        Get.bottomSheet(AddBeneBottomSheetVerify(called: "Delete"));

        print("API Running Success");
        print("Delete Non-NSDL Beneficiary API has hit");
      } else {
        Get.back();
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      Get.back();
      print("#Exception: $e");
      throw Exception('Failed to load data');
    } finally {
      // isLoading.value = false;
    }
  }
}

class BottomSheetViewBeneController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class ViewBeneBottomSheet extends StatelessWidget {
  final BottomSheetViewBeneController controller =
      Get.put(BottomSheetViewBeneController());
  final BeneficiaryDetailsController benecontroller =
      Get.put(BeneficiaryDetailsController());

  ViewBeneBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        benecontroller.dashboardController.responseData.value != null &&
        benecontroller
                .dashboardController.responseData.value!.dematAccountList !=
            null &&
        benecontroller.dashboardController.responseData.value!.dematAccountList!
            .isNotEmpty) {
      var firstAccount = benecontroller
          .dashboardController.responseData.value!.dematAccountList!.first;
      benecontroller.filterHoldingsByDPIDAndClientID(
          firstAccount.dpId!, firstAccount.clientId!);
      controller.selectedIndex(0);
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
              borderRadius: BorderRadius.only(
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
                  if (benecontroller.dashboardController.responseData.value ==
                          null ||
                      benecontroller.dashboardController.responseData.value!
                              .dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = benecontroller.dashboardController
                      .responseData.value!.dematAccountList!;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: demartAccountList.length,
                      itemBuilder: (context, index) {
                        var holdingData = demartAccountList[index];
                        return Column(
                          children: [
                            ListTile(
                              subtitle: Text(
                                "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight:
                                      controller.selectedIndex.value == index
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                  color: controller.selectedIndex.value == index
                                      ? NsdlInvestor360Colors.appMainColor
                                      : Colors.black,
                                ),
                              ),
                              onTap: () {
                                benecontroller.selectedDpId.value =
                                    holdingData.dpId!;
                                benecontroller.selectedClientId.value =
                                    holdingData.clientId!.toString();
                                benecontroller.filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                );
                                if (benecontroller.isSpecificPageActive) {
                                  benecontroller.getBeneficiaryApi(
                                    benecontroller.selectedDpId.value,
                                    benecontroller.selectedClientId.value,
                                  );
                                } else {
                                  print("Skipping API call");
                                }
                                // benecontroller.getBeneficiaryApi(
                                //     benecontroller.selectedDpId.value
                                //         .toString(),
                                //     benecontroller.selectedClientId.value
                                //         .toString());

                                controller.setSelectedIndex(index);
                                Get.back(result: {
                                  "dpId_clientId":
                                      "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                });
                              },
                              title: Text(
                                "${demartAccountList[index].dpName}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight:
                                      controller.selectedIndex.value == index
                                          ? FontWeight.w500
                                          : FontWeight.w500,
                                  color: controller.selectedIndex.value == index
                                      ? NsdlInvestor360Colors.appMainColor
                                      : Colors.grey[600],
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
                      },
                    ),
                  );
                }),
              ],
            ),
          );
        });
  }
}
