import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/dashboard/data/dashboard_repo.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/data/service_report_repo.dart';
import 'package:investor360/modules/service_reports/model/getSotFIleRequest.dart';
import 'package:investor360/modules/service_reports/model/getSotListRequest.dart';
import 'package:investor360/modules/service_reports/model/getSotListResponse.dart';
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

class StatementTransactController extends GetxController {
  var isLoading = false.obs;
  var fileIsDownloaded = false.obs;
  // Set<String> downloadedFiles = {};
  var downloadedFiles = <String>{}.obs;
  var selectedIndex = RxnInt(0); // Default selection to 0
  var dpId_clientId = ''.obs;

  final ServiceReportRepo serviceReportRepo = ServiceReportRepo();
  final DashboardRepo dashboardRepo = DashboardRepo();
  RxList<GetSotListResponseItem> reportItems = RxList<GetSotListResponseItem>();

  dynamic selectedClientId = "".obs;
  dynamic selectedDpId = "".obs;
  TextEditingController textEditingControllerBeneidTransact =
      TextEditingController();
  final DashboardController dashboardController =
      Get.put(DashboardController());

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

  void initializeData() async {
    await setInitialDpIdAndClientId();
    if (selectedDpId.value.isNotEmpty && selectedClientId.value.isNotEmpty) {
      getSotListAPI(
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
        textEditingControllerBeneidTransact.text =
            selectedDpId.value + "-" + selectedClientId.value;
      }
    }
  }

  void selectFirstItem() {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.dematAccountList != null &&
        dashboardController.responseData.value!.dematAccountList!.isNotEmpty) {
      var firstAccount =
          dashboardController.responseData.value!.dematAccountList!.first;
      selectedDpId = firstAccount.dpId;
      selectedClientId = firstAccount.clientId;
      filterHoldingsByDPIDAndClientID(firstAccount.dpId, firstAccount.clientId);

      selectedIndex.value = 0;
    }
  }

  Future<void> getSotListAPI(String dpid, String clientId) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    var pan = prefs.getString(KeyConstants.pan);

    if (sessionId == null || pan == null) {
      print("Session ID or PAN is missing in SharedPreferences");
      isLoading.value = false;

      return;
    }

    GetSotListRequest sotListRequest = GetSotListRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId,
      dpId: dpid,
      clientId: clientId,
      pan: pan,
    );
    sotListRequest.signCS = getSignChecksum(sotListRequest.toString(), "");

    try {
      var res = await serviceReportRepo.getSotList(sotListRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
        var body = res.data;
        if (response.responseCode == "0") {
          GetSotListResponse getSotListResponse =
              GetSotListResponse.fromJson(body);
          List<GetSotListResponseItem> fetchedItems =
              getSotListResponse.data ?? [];
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

  /* void downloadFile(String fileId) {
    print("Download file with ID: $fileId");
    getSotFileApi(fileId);
  }*/

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

  Future<void> getSotFileApi(String fileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    final directory = await _getDownloadDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/$fileId.csv';
      final file = File(filePath);

      if (await file.exists()) {
        print("File already exists, opening saved file.");

        openCSV(filePath);

        // If file exists, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);

        return;
      }
    } else {
      print('Could not find the download directory');
      return;
    }

    GetSotFileRequest sotFileRequest = GetSotFileRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      fileId: fileId,
    );
    sotFileRequest.signCS = getSignChecksum(sotFileRequest.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await serviceReportRepo.getSotFile(sotFileRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        Uint8List csvData = res.data;
        await saveCSV(csvData, fileId);

        // After saving the file, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);

        print("API Running Success");
        print("getSotFile API has hit ");
      } else {
        PopUpLoading.onLoadingOff(Get.context!);
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: $e");
      throw Exception('Failed to load data');
    }
  }

/*

  Future<void> getSotFileApi(String fileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    final directory = await _getDownloadDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/$fileId.csv';
      final file = File(filePath);

      if (await file.exists()) {
        print("File already exists, opening saved file.");
        openCSV(filePath);

        // If file exists, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);

        return;
      }
    } else {
      print('Could not find the download directory');
      return;
    }

    GetSotFileRequest sotFileRequest = GetSotFileRequest(sessionId: sessionId!, fileId: fileId);

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await serviceReportRepo.getSotFile(sotFileRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        Uint8List csvData = res.data;
        await saveCSV(csvData, fileId);

        // After saving the file, add fileId to downloadedFiles set
        downloadedFiles.add(fileId);

        print("API Running Success");
        print("getSotFile API has hit ");
      } else {
        PopUpLoading.onLoadingOff(Get.context!);
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: $e");
      throw Exception('Failed to load data');
    }
  }

*/

  Future<void> saveCSV(Uint8List csvBytes, String fileName) async {
    try {
      // Log the length of the bytes to ensure data is being passed correctly
      print('CSV byte length: ${csvBytes.length}');

      // Request storage permission
      if (await _requestPermissions()) {
        final directory = await _getDownloadDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/$fileName.csv';
          final file = File(filePath);

          // Log the length of the bytes to ensure data is being passed correctly
          print('CSV byte length before writing: ${csvBytes.length}');
          await file.writeAsBytes(csvBytes,
              flush: true); // Ensure data is flushed to disk

          print('CSV saved at $filePath');

          // Verify the content of the saved file
          final readFile = await file.readAsBytes();
          print('Read file byte length: ${readFile.length}');
          if (csvBytes.length != readFile.length) {
            print('Mismatch in byte length after saving file.');
            return;
          }

          for (int i = 0; i < csvBytes.length; i++) {
            if (csvBytes[i] != readFile[i]) {
              print('Mismatch in byte content at index $i.');
              return;
            }
          }
          print('CSV content verified successfully.');

          // Open the CSV file
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
      print('Failed to save or open CSV: $e');
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

  void openCSV(String filePath) {
    OpenFile.open(filePath).then((result) {
      print('Open file result: ${result.message}');
    }).catchError((error) {
      print('Failed to open file: $error');
    });
  }

/*  Future<void> getSotFileApi(String fileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    GetSotFileRequest sotFileRequest =
        GetSotFileRequest(sessionId: sessionId!, fileId: fileId);

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await serviceReportRepo.getSotFile(sotFileRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        Uint8List csvData = res.data;
        await saveCSV(csvData, fileId);

        print("API Running Success");
        print("getSotFile API has hit ");
      } else {
        PopUpLoading.onLoadingOff(Get.context!);
        print("API call failed with status code: ${res?.statusCode}");
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: $e");
      throw Exception('Failed to load data');
    }
  }

  Future<void> saveCSV(Uint8List csvBytes, String fileName) async {
    try {
      // Log the length of the bytes to ensure data is being passed correctly
      print('CSV byte length: ${csvBytes.length}');

      // Request storage permission
      if (await _requestPermissions()) {
        final directory = await _getDownloadDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/$fileName.csv';
          final file = File(filePath);

          // Log the length of the bytes to ensure data is being passed correctly
          print('CSV byte length before writing: ${csvBytes.length}');
          await file.writeAsBytes(csvBytes,
              flush: true); // Ensure data is flushed to disk

          print('CSV saved at $filePath');

          // Verify the content of the saved file
          final readFile = await file.readAsBytes();
          print('Read file byte length: ${readFile.length}');
          if (csvBytes.length != readFile.length) {
            print('Mismatch in byte length after saving file.');
            return;
          }

          for (int i = 0; i < csvBytes.length; i++) {
            if (csvBytes[i] != readFile[i]) {
              print('Mismatch in byte content at index $i.');
              return;
            }
          }
          print('CSV content verified successfully.');

          // Open the CSV file
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
      print('Failed to save or open CSV: $e');
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

  void openCSV(String filePath) {
    OpenFile.open(filePath).then((result) {
      print('Open file result: ${result.message}');
    }).catchError((error) {
      print('Failed to open file: $error');
    });
  }*/
}

class BottomSheetTransctController extends GetxController {
  var selectedIndex = RxnInt();

  void resetSelection() {
    selectedIndex.value = null;
  }

  void setSelectedIndex(int? index) {
    selectedIndex.value = index;
  }
}

class statementTransactBottomSheet extends StatelessWidget {
  final BottomSheetTransctController controller =
      Get.put(BottomSheetTransctController());
  final StatementTransactController statementTransactController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Ensure the first item is selected by default
    if (controller.selectedIndex.value == null &&
        statementTransactController.dashboardController.responseData.value !=
            null &&
        statementTransactController
                .dashboardController.responseData.value!.dematAccountList !=
            null &&
        statementTransactController.dashboardController.responseData.value!
            .dematAccountList!.isNotEmpty) {
      var firstAccount = statementTransactController
          .dashboardController.responseData.value!.dematAccountList!.first;
      statementTransactController.filterHoldingsByDPIDAndClientID(
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
                  if (statementTransactController
                              .dashboardController.responseData.value ==
                          null ||
                      statementTransactController.dashboardController
                              .responseData.value!.dematAccountList ==
                          null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var demartAccountList = statementTransactController
                      .dashboardController
                      .responseData
                      .value!
                      .dematAccountList!;

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
                                statementTransactController.selectedDpId.value =
                                    holdingData.dpId!;
                                statementTransactController.selectedClientId
                                    .value = holdingData.clientId!.toString();
                                statementTransactController
                                    .filterHoldingsByDPIDAndClientID(
                                  holdingData.dpId!,
                                  holdingData.clientId!,
                                );
                                statementTransactController.getSotListAPI(
                                    statementTransactController
                                        .selectedDpId.value
                                        .toString(),
                                    statementTransactController
                                        .selectedClientId.value
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
