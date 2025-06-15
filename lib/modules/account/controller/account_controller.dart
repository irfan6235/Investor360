import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/data/dashboard_repo.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataRequest.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/loading/popup_loading.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/base_request.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/controller/dashboard_controller.dart';

class AccountController extends GetxController {
  // Reactive variables
  RxString mobileNumber = RxString("");
  RxString panNo = RxString("");
  RxString mobile = RxString("");
  RxString pan = RxString("");
  RxString status = "".obs;
  RxBool isMobileVisible = RxBool(false);
  RxBool isNomineePanVisible = RxBool(false);
  RxBool isPanVisible = RxBool(false);
  RxBool isHiddenM = RxBool(false);
  RxBool isHiddeNomineP = RxBool(false);
  RxBool isHiddenP = RxBool(false);
  RxString statusDescriptions = RxString("Please Select a Beneficiary Id");
  RxString email = RxString("Please Select a Beneficiary Id");
  RxString address = RxString("");
  var dpId_clientId = ''.obs;
  var isLoading = false.obs;
  var selectedIndex = RxnInt(0); // Default selection to 0
  List<DematAccountList> aggregatedHoldings = [];
  RxInt selectedDropdownIndex = RxInt(0);
  var isHiddeNominePList = <RxBool>[].obs;

  var accountDematList = DematAccountList().obs;

  var isAccountDataLoaded = false.obs;

  final DashboardRepo dashboardRepo = DashboardRepo();
  //Rx<GetNsdlHoldingDataResponse?> responseData = Rx<GetNsdlHoldingDataResponse?>(null);
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final BottomSheetAccountController controller =
      Get.put(BottomSheetAccountController());
  dynamic selectedClientId = "".obs;
  TextEditingController textEditingControllerBeneidAccount =
      TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    print(" here val : ${isAccountDataLoaded.value}");
    initializeData();
    // await fetchNsdlHoldingDataApiAccount();
    selectFirstItem();
    controller.setSelectedIndex(0);
    isHiddeNominePList.value = List.generate(
        accountDematList.value.nomineeList!.length, (index) => false.obs);
    updateTextFieldWithInitialSelection(); // Update text field with initial selection
  }

  void updateTextFieldWithInitialSelection() {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.dematAccountList != null &&
        dashboardController.responseData.value!.dematAccountList!.isNotEmpty) {
      var initialSelection =
          dashboardController.responseData.value!.dematAccountList![0];
      var dpIdClientId =
          "${initialSelection.dpId}-${initialSelection.clientId}";
      textEditingControllerBeneidAccount.text = dpIdClientId;
      dpId_clientId.value = dpIdClientId;
    }
  }

  void selectFirstItem() {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.dematAccountList != null &&
        dashboardController.responseData.value!.dematAccountList!.isNotEmpty) {
      var firstAccount =
          dashboardController.responseData.value!.dematAccountList!.first;
      filterHoldingsByDPIDAndClientID(firstAccount.dpId, firstAccount.clientId);
      selectedIndex.value = 0;
    }
  }

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }

  void filterHoldingsByDPIDAndClientID(var dpId, var clientId) {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.holdingDataList != null) {
      if (dpId == "ALL") {
        selectedClientId.value = "ALL";
      } else if (dpId == null || clientId == null) {
        accountDematList.value = null!;
        //   statusDescriptions.value = "";
        // email.value = "";
        //selectedClientId.value = "";
      } else {
        accountDematList.value = dashboardController
            .responseData.value!.dematAccountList!
            .firstWhere(
                (account) =>
                    account.dpId == dpId && account.clientId == clientId,
                orElse: () => DematAccountList(address: ""));

/*        accountDematList = dashboardController.responseData.value!.dematAccountList!
            .firstWhere((account) => account.dpId == dpId && account.clientId == clientId, orElse: () => DematAccountList(address: ""));

        email.value = account.emailId;
        address.value = account.address ?? "";
        statusDescriptions.value = account.statusDescription;*/
        selectedClientId.value = clientId.toString();
      }
    }
  }

  Future<void> fetchNsdlHoldingDataApiAccount() async {
    GetNsdlHoldingDataRequest getNsdlHoldingDataRequest =
        GetNsdlHoldingDataRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    getNsdlHoldingDataRequest.channelId = "Device";
    getNsdlHoldingDataRequest.deviceId = await getDeviceId();
    getNsdlHoldingDataRequest.deviceOS = getDeviceOS();
    getNsdlHoldingDataRequest.sessionId = sessionId;
    getNsdlHoldingDataRequest.signCS =
        getSignChecksum(getNsdlHoldingDataRequest.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);
      var res =
          await dashboardRepo.getNsdlHoldingDataApi(getNsdlHoldingDataRequest);

      if (res is String) {
        print('Failed to fetch data: $res');
        PopUpLoading.onLoadingOff(Get.context!);
        throw Exception('Failed to load data: $res');
      } else {
        final jsonResponse = res.data;

        if (jsonResponse == null) {
          PopUpLoading.onLoadingOff(Get.context!);
          throw Exception('Failed to load data: response data is null');
        }

        dashboardController.responseData.value =
            GetNsdlHoldingDataResponse.fromJson(jsonResponse);
        PopUpLoading.onLoadingOff(Get.context!);
        selectFirstItem(); // Ensure first item is selected after data fetch
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception " + e.toString());
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  void onClose() {
    isMobileVisible.value = false;
    isPanVisible.value = false;
    isNomineePanVisible.value = false;
    super.onClose();
  }

  String obscureMobileNumber(String number) {
    if (number.length > 6) {
      String firstTwoDigits = number.substring(0, 2);
      String lastFourDigits = number.substring(number.length - 4);
      String obscuredDigits = '*' * (number.length - 6);
      return firstTwoDigits + obscuredDigits + lastFourDigits;
    } else if (number.length > 4) {
      return number;
    } else {
      return number;
    }
  }

  void initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber.value = prefs.getString(KeyConstants.mobileKey) ?? '';
    panNo.value = prefs.getString(KeyConstants.pan) ?? '';
    mobile.value = obscureMobileNumber(mobileNumber.value);
    pan.value = obscureMobileNumber(panNo.value);
  }

  void toggleMobileVisibility() {
    isMobileVisible.toggle();
  }

  void togglePanVisibility() {
    isPanVisible.toggle();
  }

  // void toggleNoomineePanVisibility(int index) {
  //   isHiddeNominePList[index].value = !isHiddeNominePList[index].value;
  // }

  void onDematAccountChanged() {
    final int nomineeCount = accountDematList.value.nomineeList!.length;
    isHiddeNominePList.clear();
    for (int i = 0; i < nomineeCount; i++) {
      isHiddeNominePList.add(
          RxBool(true)); // Default all to true (or false based on your logic)
    }
  }
}

class BottomSheetAccountController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class AccountBottomSheet extends StatelessWidget {
  final BottomSheetAccountController controller =
      Get.put(BottomSheetAccountController());
  final AccountController accountController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        accountController.dashboardController.responseData.value != null &&
        accountController
                .dashboardController.responseData.value!.dematAccountList !=
            null &&
        accountController.dashboardController.responseData.value!
            .dematAccountList!.isNotEmpty) {
      var firstAccount = accountController
          .dashboardController.responseData.value!.dematAccountList!.first;
      accountController.filterHoldingsByDPIDAndClientID(
          firstAccount.dpId!, firstAccount.clientId!);
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
                  if (accountController
                              .dashboardController.responseData.value ==
                          null ||
                      accountController.dashboardController.responseData.value!
                              .dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = accountController.dashboardController
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
                                      :darkMode? Colors.white:Colors.black,
                                ),
                              ),
                              onTap: () {
                                accountController
                                    .filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                );
                                controller.setSelectedIndex(index);
                                Get.back(result: {
                                  "dpId_clientId":
                                      "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                });
                                accountController.onDematAccountChanged();
                              },
                              title: Text(
                                "${demartAccountList[index].dpName}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      controller.selectedIndex.value == index
                                          ? FontWeight.w500
                                          : FontWeight.w500,
                                  color: controller.selectedIndex.value == index
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
