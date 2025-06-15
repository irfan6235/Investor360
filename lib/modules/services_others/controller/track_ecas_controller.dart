import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/services_others/data/service_other_repo.dart';
import 'package:investor360/modules/services_others/model/ecasStatusTrackRequest.dart';
import 'package:investor360/modules/services_others/model/getEcasDetailRequest.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackEcasController extends GetxController {
  TextEditingController emailController = TextEditingController();
  final ServiceOtherRepo serviceOtherRepo = ServiceOtherRepo();
  RxBool isLoading = false.obs;

  // Make selectedYear1, selectedYear2, and selectedMonth reactive
  RxString? selectedYear1 = RxString('');
  RxString? selectedYear2 = RxString('');
  RxString? selectedMonth = RxString('');

  final DashboardController dashboardController =
      Get.put(DashboardController());
  var accountDematList = DematAccountList().obs;

  @override
  void onInit() {
    selectFirstItem();

    super.onInit();
  }

  void selectFirstItem() {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.dematAccountList != null &&
        dashboardController.responseData.value!.dematAccountList!.isNotEmpty) {
      var firstAccount =
          dashboardController.responseData.value!.dematAccountList!.first;
      filterHoldingsByDPIDAndClientID(firstAccount.dpId, firstAccount.clientId);
    }
  }

  void filterHoldingsByDPIDAndClientID(var dpId, var clientId) {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.holdingDataList != null) {
      accountDematList.value =
          dashboardController.responseData.value!.dematAccountList!.firstWhere(
              (account) => account.dpId == dpId && account.clientId == clientId,
              orElse: () => DematAccountList(address: ""));

/*        accountDematList = dashboardController.responseData.value!.dematAccountList!
            .firstWhere((account) => account.dpId == dpId && account.clientId == clientId, orElse: () => DematAccountList(address: ""));

        email.value = account.emailId;
        address.value = account.address ?? "";
        statusDescriptions.value = account.statusDescription;*/
    }
  }

  Future<void> trackEcasRequest(String email) async {
    EcasStatusTrackRequest ecasstatustrack = EcasStatusTrackRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);

    ecasstatustrack.channelId = "Device";
    ecasstatustrack.deviceId = await getDeviceId();
    ecasstatustrack.deviceOS = getDeviceOS();
    ecasstatustrack.sessionId = sessionId;
    ecasstatustrack.email = email;
    ecasstatustrack.month = selectedMonth?.value;
    ecasstatustrack.pan = pan;
    ecasstatustrack.year = selectedYear1?.value;
    ecasstatustrack.signCS = getSignChecksum(ecasstatustrack.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceOtherRepo.trackEcasStatus(ecasstatustrack);

      if (res != null && res.statusCode == 200) {
        Map<String, dynamic> mainJson;
        if (res.data is String) {
          showSnackBar(Get.context!, "Request has been successfully sent");
          mainJson = jsonDecode(res.data);
        } else if (res.data is Map<String, dynamic>) {
          showSnackBar(Get.context!, "Request has been successfully sent");
          mainJson = res.data;
        } else {
          throw Exception('Unexpected response format');
        }

        if (mainJson['responseCode'] == "1" ||
            mainJson['responseCode'] == "-1") {
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }
        Get.toNamed(Routes.trackEcas.name);
      } else {
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getEcasDetailsApi(String dpid, String clientId) async {
    EcasDetailRequest ecasDetailRequest = EcasDetailRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    ecasDetailRequest.channelId = "Device";
    ecasDetailRequest.deviceId = await getDeviceId();
    ecasDetailRequest.deviceOS = getDeviceOS();
    ecasDetailRequest.sessionId = sessionId;
    ecasDetailRequest.clientid = clientId;
    ecasDetailRequest.dpId = dpid;
    ecasDetailRequest.month = "";
    ecasDetailRequest.pan = pan;
    ecasDetailRequest.year = "";

/*    getEcasRequest.clientId = "12055001";
    getEcasRequest.dpId = "IN487875";
    getEcasRequest.pan = "AIXPA0945R";*/
    ecasDetailRequest.signCS =
        getSignChecksum(ecasDetailRequest.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceOtherRepo.getEcas(ecasDetailRequest);

      if (res != null && res.statusCode == 200) {
        Map<String, dynamic> mainJson;

        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else if (res.data is Map<String, dynamic>) {
          mainJson = res.data;
        } else {
          throw Exception('Unexpected response format');
        }

        if (mainJson['responseCode'] == "1" ||
            mainJson['responseCode'] == "-1") {
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        // Parse the 'data' field as a JSON string
        var dataString = mainJson['data'];
        print("Data Field: $dataString");

        // Ensure the 'data' string is properly parsed to a Map
        var data = jsonDecode(dataString);

        // Now 'data' should be a valid Map<String, dynamic>
        if (data != null && data is Map<String, dynamic>) {
          bool isSubscribed = data['subscribed'] ?? false;
          String? email = data['email'];

          if (isSubscribed && email != null && email.isNotEmpty) {
            print("Subscribed email: $email");

            emailController.text = email;
          } else {
            emailController.text = accountDematList.value.emailId;
          }
        } else {
          print("Failed to parse 'data' as Map.");
          showSnackBar(Get.context!, "Invalid data in response");
        }
      } else {
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
