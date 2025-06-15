import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/data/service_report_repo.dart';
import 'package:investor360/modules/service_reports/model/GetEcasPdfRequest.dart';
import 'package:investor360/modules/service_reports/model/getEcasRequest.dart';
import 'package:investor360/modules/service_reports/model/getEcasResponse.dart';
import 'package:investor360/modules/service_reports/views/ecas.dart';
import 'package:investor360/shared/loading/popup_loading.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

import 'dart:convert';

import '../../../shared/style/colors.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../model/getEcasRequest.dart';

class EcasController extends GetxController {
  late String selectedFile;
  late String selectedFullKey;
  RxList<String> fileNames = <String>[].obs;

  final ServiceReportRepo serviceReportRepo = ServiceReportRepo();
  RxBool isLoading = false.obs;
//  Rx<EcasResponse?> responseData = Rx<EcasResponse?>(null);
  Rx<List<EcasResponse>?> responseData = Rx<List<EcasResponse>?>(null);

  TextEditingController textEditingControllerBeneidEcas =
      TextEditingController();
  var dpId_clientId = ''.obs;
  final DashboardController dashboardController =
      Get.put(DashboardController());
  var selectedClientId = "".obs;
  var selectedDpId = "".obs;

  @override
  void onInit() {
    super.onInit();

    initializeData();
  }

  void initializeData() async {
    await setInitialDpIdAndClientId();
    if (selectedDpId.value.isNotEmpty && selectedClientId.value.isNotEmpty) {
      fetchDropdownData(
          selectedDpId.value.toString(), selectedClientId.value.toString());
    }
  }

  Future<void> setInitialDpIdAndClientId() async {
    if (dashboardController.responseData.value != null) {
      var dematAccountList =
          dashboardController.responseData.value!.dematAccountList;
      if (dematAccountList != null) {
        selectedDpId.value = dematAccountList![0].dpId ?? "";
        selectedClientId.value = dematAccountList![0].clientId.toString() ?? "";
        textEditingControllerBeneidEcas.text =
            selectedDpId.value + "-" + selectedClientId.value;
      }
    }
  }

  Future<void> fetchDropdownData(String dpid, String clientId) async {
    GetEcasRequest getEcasRequest = GetEcasRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    getEcasRequest.channelId = "Device";
    getEcasRequest.deviceId = await getDeviceId();
    getEcasRequest.deviceOS = getDeviceOS();
    getEcasRequest.sessionId = sessionId;
    getEcasRequest.clientId = clientId;
    getEcasRequest.dpId = dpid;
    getEcasRequest.pan = pan;

/*    getEcasRequest.clientId = "12055001";
    getEcasRequest.dpId = "IN487875";
    getEcasRequest.pan = "AIXPA0945R";*/
    getEcasRequest.signCS = getSignChecksum(getEcasRequest.toString(), "");

    try {
      isLoading.value = true;
      var res = await serviceReportRepo.getEcas(getEcasRequest);

      if (res != null && res.statusCode == 200) {
        Map<String, dynamic> mainJson;
        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else if (res.data is Map<String, dynamic>) {
          mainJson = res.data;
        } else {
          throw Exception('Unexpected response format');
        }

        if (mainJson['responseCode'] == "1"  || mainJson['responseCode'] == "-1") {
          // PopUpLoading.onLoadingOff(Get.context!);
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        BaseResponse<List<EcasResponse>> response = BaseResponse.fromJson(
          mainJson,
          (dataJson) {
            if (dataJson is String) {
              var decodedData = jsonDecode(dataJson);
              return List<EcasResponse>.from(
                  decodedData.map((item) => EcasResponse.fromJson(item)));
            }
            return [];
          },
        );

        if (response.responseCode == "0") {
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

  void updateSelectedFullKey() {
    // Ensure responseData is not null
    if (responseData.value != null && responseData.value!.isNotEmpty) {
      // Check if selectedFile exists in fileNames
      if (fileNames.value.contains(selectedFile)) {
        // Find the corresponding EcasResponse object
        EcasResponse? selectedResponse = responseData.value!.firstWhere(
          (response) => response.fileName == selectedFile,
          orElse: () => null!,
        );

        // Update selectedFullKey based on selectedResponse
        selectedFullKey = selectedResponse?.fullKey ?? '';
        print("selectedFullKey: $selectedFullKey");
      } else {
        // If selectedFile doesn't exist in fileNames, reset selectedFullKey
        selectedFullKey = '';
      }
    } else {
      // If responseData is null or empty, reset selectedFullKey
      selectedFullKey = '';
    }

    // Trigger UI update
    update();
  }

  Future<void> ecasPadfGenerateReport(var fullKey, var fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    GetEcasPdfRequest getEcasPdfRequest = GetEcasPdfRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      casId: fullKey,
    );
    getEcasPdfRequest.signCS =
        getSignChecksum(getEcasPdfRequest.toString(), "");

    try {
      //  isLoading.value = true;
      PopUpLoading.onLoading(Get.context!);

      var res = await serviceReportRepo.getEcasPdf(getEcasPdfRequest);

      if (res is String) {
        print('Failed to fetch data: $res');
        PopUpLoading.onLoadingOff(Get.context!);
        throw Exception('Failed to load data: $res');
      } else {
        PopUpLoading.onLoadingOff(Get.context!);

        Uint8List pdfData;
        if (res.data is String) {
          pdfData = base64Decode(res.data as String);
        } else if (res.data is Uint8List) {
          pdfData = res.data;
        } else {
          throw Exception('Unexpected response type: ${res.data.runtimeType}');
        }

        await savePDF(pdfData, fileName);

        /*  final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName.pdf';
        final file = File(filePath);
        await file.writeAsBytes(pdfData);

        // Open the PDF
        await OpenFile.open(filePath);*/
      }
    } catch (e) {
      // isLoading.value = false;
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: " + e.toString());
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> savePDF(Uint8List pdfBytes, String fileName) async {
    try {
      // Log the length of the bytes to ensure data is being passed correctly
      print('PDF byte length: ${pdfBytes.length}');

      // Request storage permission
      if (await _requestPermissions()) {
        final directory = await _getDownloadDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/$fileName.pdf';
          final file = File(filePath);

          // Log the length of the bytes to ensure data is being passed correctly
          print('PDF byte length before writing: ${pdfBytes.length}');
          await file.writeAsBytes(pdfBytes,
              flush: true); // Ensure data is flushed to disk

          print('PDF saved at $filePath');

          // Verify the content of the saved file
          final readFile = await file.readAsBytes();
          print('Read file byte length: ${readFile.length}');
          if (pdfBytes.length != readFile.length) {
            print('Mismatch in byte length after saving file.');
            return;
          }

          for (int i = 0; i < pdfBytes.length; i++) {
            if (pdfBytes[i] != readFile[i]) {
              print('Mismatch in byte content at index $i.');
              return;
            }
          }
          print('PDF content verified successfully.');

          // Open the PDF file
          final result = await OpenFile.open(filePath);
          print(
              'Open file result: ${result.message}'); // Check if there's any error message
        } else {
          print('Could not find the download directory');
        }
      } else {
        print('Storage permission denied');
      }
    } catch (e) {
      print('Failed to save or open PDF: $e');
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid && await _isAndroid11OrAbove()) {
      final status = await Permission.manageExternalStorage.request();
      return status == PermissionStatus.granted;
    } else {
      final status = await [
        Permission.storage,
      ].request();
      return status[Permission.storage] == PermissionStatus.granted;
    }
  }

  Future<bool> _isAndroid11OrAbove() async {
    return Platform.isAndroid && (await _getAndroidSdkInt()) >= 30;
  }

  Future<int> _getAndroidSdkInt() async {
    final release = await _getAndroidRelease();
    if (release != null && release.isNotEmpty) {
      return int.parse(release);
    }
    return 0;
  }

  Future<String?> _getAndroidRelease() async {
    final ProcessResult result =
        await Process.run('getprop', ['ro.build.version.sdk']);
    if (result.exitCode == 0) {
      return result.stdout.toString().trim();
    }
    return null;
  }

  void openPDF(String filePath) {
    OpenFile.open(filePath).then((result) {
      print('Open file result: ${result.message}');
    }).catchError((error) {
      print('Failed to open file: $error');
    });
  }

/*  void updateSelectedFullKey() {
    selectedFullKey = responseData.value?.docList
            ?.firstWhere((doc) => doc.fileName == selectedFile,
                orElse: () => DocList(fullKey: '', fileName: ''))
            .fullKey ??
        '';
    update();
  }*/

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
}

class BottomSheetECASController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class EcasBottomSheet extends StatelessWidget {
  final BottomSheetECASController controller =
      Get.put(BottomSheetECASController());
  final EcasController ecasController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        ecasController.dashboardController.responseData.value != null &&
        ecasController
                .dashboardController.responseData.value!.dematAccountList !=
            null &&
        ecasController.dashboardController.responseData.value!.dematAccountList!
            .isNotEmpty) {
      var firstAccount = ecasController
          .dashboardController.responseData.value!.dematAccountList!.first;
      ecasController.filterHoldingsByDPIDAndClientID(
          firstAccount.dpId!, firstAccount.clientId!);
      controller.setSelectedIndex(0);
    }
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
                  if (ecasController.dashboardController.responseData.value ==
                          null ||
                      ecasController.dashboardController.responseData.value!
                              .dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = ecasController.dashboardController
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
                                      :  darkMode? Colors.white:Colors.black,
                                ),
                              ),
                              onTap: () {
                                ecasController.selectedDpId.value =
                                    holdingData.dpId!;
                                ecasController.selectedClientId.value =
                                    holdingData.clientId!.toString();
                                ecasController.filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                );
                                ecasController.fetchDropdownData(
                                    ecasController.selectedDpId.value,
                                    ecasController.selectedClientId.value
                                        .toString());
                                controller.setSelectedIndex(index);
                                Get.back(result: {
                                  "dpId_clientId":
                                      "${demartAccountList[index].dpId}- ${demartAccountList[index].clientId}",
                                });
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
