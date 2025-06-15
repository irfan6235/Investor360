import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/services_others/data/service_other_repo.dart';
import 'package:investor360/modules/services_others/model/getEcasDetailRequest.dart';
import 'package:investor360/modules/services_others/model/subscribeEcasRequest.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscribeEcasController extends GetxController {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController panController = TextEditingController();

  final ServiceOtherRepo serviceOtherRepo = ServiceOtherRepo();
  RxBool isLoading = false.obs;
  RxBool subscribed = false.obs;
  final DashboardController dashboardController =
      Get.put(DashboardController());
  var accountDematList = DematAccountList().obs;

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pan = prefs.getString(KeyConstants.pan);
    // var email = prefs.getString(KeyConstants.email);
    selectFirstItem();
    if (pan != "" || pan != null) {
      panController.text = pan!;
    }

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
            subscribed.value = true;
            emailcontroller.text = email;
            Get.toNamed(Routes.subscribeEcas.name, arguments: {'email': email});
          } else {
            subscribed.value = false;

            emailcontroller.text = accountDematList.value.emailId;
            Get.toNamed(Routes.subscribeEcas.name, arguments: {'email': email});
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

  Future<void> subscribeEcasApi(String dpid, String clientId) async {
    SubcribeEcasRequest subcribeEcasRequest = SubcribeEcasRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    subcribeEcasRequest.channelId = "Device";
    subcribeEcasRequest.deviceId = await getDeviceId();
    subcribeEcasRequest.deviceOS = getDeviceOS();
    subcribeEcasRequest.sessionId = sessionId;
    subcribeEcasRequest.clientid = clientId;
    subcribeEcasRequest.dpId = dpid;
    subcribeEcasRequest.email = emailcontroller.text;
    subcribeEcasRequest.pan = pan;

    subcribeEcasRequest.signCS =
        getSignChecksum(subcribeEcasRequest.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceOtherRepo.subscribeEcas(subcribeEcasRequest);

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
          // PopUpLoading.onLoadingOff(Get.context!);
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        showSnackBar(Get.context!, "You Have Successful Subscribe to eCAS");

        /* BaseResponse<List<EcasResponse>> response = BaseResponse.fromJson(
          mainJson,
              (dataJson) {
            if (dataJson is String) {
              var decodedData = jsonDecode(dataJson);
              return List<EcasResponse>.from(
                  decodedData.map((item) => EcasResponse.fromJson(item)));
            }
            return [];
          },
        );*/

        /* if (response.responseCode == "0") {
          responseData.value = response.data;

          // If there are multiple files, store their names
          if (responseData.value != null && responseData.value!.isNotEmpty) {
            fileNames.value =
                responseData.value!.map((e) => e.fileName ?? '').toList();
            print("FILES NAME: " + fileNames.value.toString());

            if (fileNames.isNotEmpty) {
              selectedFile = fileNames.first;
              updateSelectedFullKey();
            }

            // Update selectedFullKey based on selectedFile
            selectedFullKey = responseData.value!.first.fullKey ??
                ''; // You may need to adjust this logic based on your requirements

            update();
          } else {
            showSnackBar(Get.context!, "No data available");
          }
        } else {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }*/
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

  // void fetchEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var email = prefs.getString(KeyConstants.email);

  //   if (email == null || email.isEmpty) {
  //     emailcontroller.text = accountDematList.value.emailId ?? '';
  //   } else {
  //     emailcontroller.text = email;
  //   }
  // }
}
