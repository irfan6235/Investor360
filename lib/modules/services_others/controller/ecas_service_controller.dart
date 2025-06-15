import 'dart:convert';

import 'package:get/get.dart';
import 'package:investor360/modules/services_others/data/service_other_repo.dart';
import 'package:investor360/modules/services_others/model/ecasStatusTrackRequest.dart';
import 'package:investor360/modules/services_others/model/updateEcasEmailRequest.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcasServicesController extends GetxController {
  final ServiceOtherRepo serviceOtherRepo = ServiceOtherRepo();
  RxBool isLoading = false.obs;

  Future<void> updateEcasEmailApi(String dpid, String clientId) async {
    UpdateEcasEmailRequest updateEcasEmailRequest = UpdateEcasEmailRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    updateEcasEmailRequest.channelId = "Device";
    updateEcasEmailRequest.deviceId = await getDeviceId();
    updateEcasEmailRequest.deviceOS = getDeviceOS();
    updateEcasEmailRequest.sessionId = sessionId;
    updateEcasEmailRequest.clientid = clientId;
    updateEcasEmailRequest.dpId = dpid;
    updateEcasEmailRequest.email = "";
    updateEcasEmailRequest.pan = pan;

    updateEcasEmailRequest.signCS =
        getSignChecksum(updateEcasEmailRequest.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceOtherRepo.updateEcasEmail(updateEcasEmailRequest);

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

  Future<void> trackEcasStatusApi(String dpid, String clientId) async {
    EcasStatusTrackRequest ecasStatusTrackRequest = EcasStatusTrackRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    ecasStatusTrackRequest.channelId = "Device";
    ecasStatusTrackRequest.deviceId = await getDeviceId();
    ecasStatusTrackRequest.deviceOS = getDeviceOS();
    ecasStatusTrackRequest.sessionId = sessionId;
    ecasStatusTrackRequest.email = "";
    ecasStatusTrackRequest.month = "";
    ecasStatusTrackRequest.pan = pan;
    ecasStatusTrackRequest.year = "pan";

    ecasStatusTrackRequest.signCS =
        getSignChecksum(ecasStatusTrackRequest.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceOtherRepo.trackEcasStatus(ecasStatusTrackRequest);

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

  List<String> getYears() {
    int currentYear = DateTime.now().year;
    List<String> years = [];
    for (int year = 2020; year <= currentYear; year++) {
      years.add(year.toString());
    }
    return years;
  }

  List<String> getFilteredMonths(int selectedYear) {
    List<String> months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    int currentMonthIndex = DateTime.now().month - 1;
    int currentYear = DateTime.now().year;

    if (selectedYear == currentYear) {
      // Exclude the current month
      List<String> filteredMonths = months.sublist(0, currentMonthIndex);
      print("Filtered months: $filteredMonths");
      return filteredMonths;
    } else {
      return months;
    }
  }
}
