import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/data/service_report_repo.dart';
import 'package:investor360/modules/service_reports/model/generateSftFileRequest.dart';
import 'package:investor360/modules/service_reports/model/getFinancialQrtzRequest.dart';
import 'package:investor360/modules/service_reports/model/getSftFileListRequest.dart';
import 'package:investor360/modules/service_reports/model/getSftFileListResponse.dart';
import 'package:investor360/modules/service_reports/model/getSoftFileRequest.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/loading/popup_loading.dart';

class SoftController extends GetxController {
  RxBool isLoading = false.obs;
  var fileIsDownloaded = false.obs;
  var downloadedFiles = <String>{}.obs;
  List<String> monthYear = [];
  RxString selectedFile = "".obs;
  // String selectedFullKey = "";

  final ServiceReportRepo serviceReportRepo = ServiceReportRepo();
  final DashboardController dashboardController =
      Get.put(DashboardController());
  var selectedClientId = "".obs;
  var selectedDpId = "".obs;
  var dpId_clientId = ''.obs;
  TextEditingController textEditingControllerSft = TextEditingController();
  RxList<GetSftFileListResponseItem> reportItems =
      RxList<GetSftFileListResponseItem>();

  // void updateSelectedFullKey() {
  //   selectedFullKey = responseData.value?.docList
  //           ?.firstWhere((doc) => doc.fileName == selectedFile,
  //               orElse: () => DocList(fullKey: '', fileName: ''))
  //           .fullKey ??
  //       '';
  //   update();
  // }

  void initializeData() async {
    await setInitialDpIdAndClientId();
    if (selectedDpId.value.isNotEmpty && selectedClientId.value.isNotEmpty) {
      // getSftFileListApi();
      fetchDropdownData();
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
          textEditingControllerSft.text =
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

  Future<void> fetchDropdownData() async {
    GetFinancialqrtzRequest getSftQrtz = GetFinancialqrtzRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);
    getSftQrtz.channelId = "Device";
    getSftQrtz.deviceId = await getDeviceId();
    getSftQrtz.deviceOS = getDeviceOS();
    getSftQrtz.sessionId = sessionId!;
    getSftQrtz.pan = pan!;
    getSftQrtz.signCS = getSignChecksum(getSftQrtz.toString(), "");

    try {
      isLoading.value = true;

      var response = await serviceReportRepo.getFinancialQrts(getSftQrtz);

      if (response != null && response.statusCode == 200) {
        CommonBaseResponse jsonResponse =
            CommonBaseResponse.fromJson(response.data);

        if (jsonResponse.responseCode == "0") {
          List<dynamic> dataList = json.decode(jsonResponse.data);
          List<String> fetchedFileNames =
              dataList.map((item) => item['monthYear'] as String).toList();

          // Update monthYear with fetched data
          monthYear.clear();
          monthYear.addAll(fetchedFileNames);

          // Set selectedFile to the first item in monthYear if available
          selectedFile.value = monthYear.isNotEmpty ? monthYear.first : '';
          getSftFileListApi(
              selectedClientId.value.toString(), selectedDpId.value.toString());
          // Trigger widget update
          update();
        } else if (jsonResponse.responseCode == "1" ||
            jsonResponse.responseCode == "-1") {
          if (jsonResponse.message == "Session Expired, Please Login again.") {
            sessionExpireHandle();
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        // Handle HTTP error status codes
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${response?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSftFileListApi(String clientId, String dpid) async {
    GetSftFileListRequest getSftFileList = GetSftFileListRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    getSftFileList.sessionId = sessionId!;
    getSftFileList.channelId = "Device";
    getSftFileList.deviceId = await getDeviceId();
    getSftFileList.deviceOS = getDeviceOS();
    getSftFileList.clientId = clientId;
    getSftFileList.dpId = dpid;
/*    getSftFileList.clientId = "12055001";
    getSftFileList.dpId = "IN487875";*/

    getSftFileList.signCS = getSignChecksum(getSftFileList.toString(), "");

    try {
      isLoading.value = true;

      var res = await serviceReportRepo.getSftFileList(getSftFileList);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
        var body = res.data;

        if (response.responseCode == "0") {
          GetSftFileListResponse getSoftListResponse =
              GetSftFileListResponse.fromJson(body);
          List<GetSftFileListResponseItem> fetchedItems =
              getSoftListResponse.data ?? [];

          // Clear previous items and assign new ones
          reportItems.clear();
          reportItems.addAll(fetchedItems);
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            sessionExpireHandle();
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        // Handle HTTP error status codes
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions thrown during the process
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      // Ensure isLoading is set to false regardless of success or failure
      isLoading.value = false;
    }
  }

  Future<void> generatesftfile(BuildContext context
      // String dpId, int clientId
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    GenerateSftFileRequest getSftQrtz = GenerateSftFileRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId,
      dpId: selectedDpId.value.toString(),
      clientId: selectedClientId.value.toString(),
      monthYear: selectedFile.value.toString(),
    );
    getSftQrtz.signCS = getSignChecksum(getSftQrtz.toString(), "");
    try {
      isLoading.value = true;

      var res = await serviceReportRepo.generateSftFile(getSftQrtz);
      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
        if (response.responseCode == "0") {
          getSftFileListApi(
            selectedClientId.value.toString(),
            selectedDpId.value.toString(),
          );
          showSnackBar(context, "Report has been generated Successfully");
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            sessionExpireHandle();
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        // Handle HTTP error status codes
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

  Future<void> initializeDownloadedFiles() async {
    final directory = await _getDownloadDirectory();
    if (directory != null) {
      final files = directory.listSync();
      for (var file in files) {
        if (file is File && file.path.endsWith('.csv')) {
          final fileId = file.uri.pathSegments.last.split('.').first;
          downloadedFiles.add(fileId);
        }
      }
    } else {
      print('Could not find the download directory');
    }
  }

  Future<void> getSoftFileAPI(String fileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    final directory = await _getDownloadDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/$fileId.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        print("File already exists, opening saved file.");

        // openCSV(filePath);
        openPDF(filePath);

        // If file exists, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);

        return;
      }
    } else {
      print('Could not find the download directory');
      return;
    }

    GetSoftFileRequest getSftFile = GetSoftFileRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      fileId: fileId,
    );
    getSftFile.signCS = getSignChecksum(getSftFile.toString(), "");

    try {
      isLoading.value = true;

      var res = await serviceReportRepo.getSftFile(getSftFile);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        Uint8List pdfData;
        if (res.data is String) {
          pdfData = base64Decode(res.data as String);
        } else if (res.data is Uint8List) {
          pdfData = res.data;
        } else {
          throw Exception('Unexpected response type: ${res.data.runtimeType}');
        }

        await savePDF(pdfData, fileId);

        // After saving the file, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);
      } else {
        PopUpLoading.onLoadingOff(Get.context!);
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      //   PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: " + e.toString());
      throw Exception('Failed to load data: $e');
    } finally {
      // isLoading.value = true;
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

          final result = await OpenFile.open(filePath);
          print('Open file result: ${result.message}');
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
}

class BottomSheetSftController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class SftBottomSheet extends StatelessWidget {
  final BottomSheetSftController controller =
      Get.put(BottomSheetSftController());
  final SoftController softController = Get.put(SoftController());
  SftBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        softController.dashboardController.responseData.value != null &&
        softController
                .dashboardController.responseData.value!.dematAccountList !=
            null &&
        softController.dashboardController.responseData.value!.dematAccountList!
            .isNotEmpty) {
      var firstAccount = softController
          .dashboardController.responseData.value!.dematAccountList!.first;
      softController.filterHoldingsByDPIDAndClientID(
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
                  if (softController.dashboardController.responseData.value ==
                          null ||
                      softController.dashboardController.responseData.value!
                              .dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = softController.dashboardController
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
                                softController.selectedDpId.value =
                                    holdingData.dpId!;
                                softController.selectedClientId.value =
                                    holdingData.clientId!.toString();
                                softController.filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                );

                                // softController.getSftFileListApi(
                                //     softController.selectedClientId.value
                                //         .toString(),
                                //     softController.selectedDpId.value
                                //         .toString());
                                softController.fetchDropdownData();

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
