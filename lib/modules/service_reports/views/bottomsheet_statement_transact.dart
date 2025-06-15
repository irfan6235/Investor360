import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/controller/statement_account_controller.dart';
import 'package:investor360/modules/service_reports/controller/statement_transact_controller.dart';
import 'package:investor360/modules/service_reports/data/service_report_repo.dart';
import 'package:investor360/modules/service_reports/model/createSotFileRequest.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/style/colors.dart';
import '../../../utils/common_utils.dart';

class StatementTranscationBottomSheetController extends GetxController {
  final ServiceReportRepo serviceReportRepo = ServiceReportRepo();
  var isDateError = false.obs;
  RxString errorMessage = "".obs;
  var selectedCustomDateList = <CustomDate>[].obs;
  final StatementTransactController controller =
      Get.put(StatementTransactController());
  var selectedFromDate = Rxn<
      DateTime>(); // Changed from DateTime.now().subtract(const Duration(days: 30)).obs;
  var selectedToDate = Rxn<DateTime>();
  var selectedDateRange = ''.obs;
  void resetSelection() {
    selectedCustomDateList.clear();
  }

  // @override
  // void onInit() async {
  //   super.onInit();
  //   if (selectedClientId != "" && selectedDpId != "") {
  //     selectedClientId = controller.selectedClientId;
  //     selectedDpId = controller.selectedDpId;
  //   } else {
  //     selectedClientId = controller.selectedClientId;
  //     selectedDpId = controller.selectedDpId;
  //   }
  // }

  void pickFromDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstSelectableDate = now.subtract(const Duration(days: 30));
    // DateTime lastSelectableDate = now.subtract(const Duration(days: 1));
    DateTime lastSelectableDate = now;

    DateTime? pickedDate = await showDatePicker(
      // initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: selectedFromDate.value ?? lastSelectableDate,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
    );

    if (pickedDate != null) {
      selectedFromDate.value = pickedDate;
      selectedDateRange.value = "";
      isDateError.value = false;
    }
  }

  void pickToDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstSelectableDate =
        selectedFromDate.value ?? now.subtract(const Duration(days: 30));
    // DateTime lastSelectableDate = now.subtract(const Duration(days: 1));
    DateTime lastSelectableDate = now;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedToDate.value ?? lastSelectableDate,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
    );

    if (pickedDate != null) {
      selectedToDate.value = pickedDate;
      selectedDateRange.value = "";
      isDateError.value = false;
    }
  }

  Future<void> createSotFileAPI(String fromDate, String toDate,
      BuildContext context, String clientIdd, String dpIdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    CreateSotFileRequest createSotFileRequest = CreateSotFileRequest();
    createSotFileRequest.channelId = "Device";
    createSotFileRequest.sessionId = sessionId;
    createSotFileRequest.deviceId = await getDeviceId();
    createSotFileRequest.deviceOS = getDeviceOS();
    createSotFileRequest.fromDate = fromDate;
    createSotFileRequest.toDate = toDate;
    createSotFileRequest.dpId = dpIdd;
    createSotFileRequest.clientId = clientIdd;

    createSotFileRequest.signCS =
        getSignChecksum(createSotFileRequest.toString(), "");

    try {
      var res = await serviceReportRepo.createSotFile(createSotFileRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
        if (response.responseCode == "0") {
          controller.getSotListAPI(controller.selectedDpId.value.toString(),
              controller.selectedClientId.value.toString());

          Get.back();
          showSnackBar(context, "Report has been generated Successfully");
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            sessionExpireHandle();
          } else {
            Get.back();
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        // Handle HTTP error status codes
        Get.back();

        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions thrown during the process
      Get.back();

      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    }
  }

  void setCustomDateRange(String type) {
    DateTime now = DateTime.now();
    selectedDateRange.value = type; // Update selected date range

    switch (type) {
      case "Previous Day":
        selectedFromDate.value = now.subtract(const Duration(days: 1));
        selectedToDate.value = now.subtract(const Duration(days: 1));
        isDateError.value = false;
        break;
      case "Last 7 Days":
        selectedFromDate.value = now.subtract(const Duration(days: 8));
        selectedToDate.value = now.subtract(const Duration(days: 1));
        isDateError.value = false;

        break;
      case "Last 15 Days":
        selectedFromDate.value = now.subtract(const Duration(days: 16));
        selectedToDate.value = now.subtract(const Duration(days: 1));
        isDateError.value = false;

        break;
      case "Last 30 Days":
        selectedFromDate.value = now.subtract(const Duration(days: 30));
        selectedToDate.value = now.subtract(const Duration(days: 1));
        isDateError.value = false;

        break;

      default:
        break;
    }
  }
}

class StatementTranscationBottomSheet extends StatelessWidget {
  final StatementTranscationBottomSheetController controller =
      Get.put(StatementTranscationBottomSheetController());
  final StatementTransactController transactController =
      Get.put(StatementTransactController());
  StatementTranscationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        controller.isDateError.value = false;
        controller.errorMessage.value = "";
        controller.selectedFromDate.value = null;
        controller.selectedToDate.value = null;
        controller.selectedDateRange.value = "";
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          decoration:  BoxDecoration(
            color: darkMode? NsdlInvestor360Colors.darkmodeBlack: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      //  color: NsdlInvestor360Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "From",
                                labelStyle: const TextStyle(
                                //  color: Colors.black,
                                ),
                                hintText: 'Select Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () =>
                                      controller.pickFromDate(context),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              controller: TextEditingController(
                                text: controller.selectedFromDate.value != null
                                    ? DateFormat('dd MMM yyyy').format(
                                        controller.selectedFromDate.value!,
                                      )
                                    : 'Select Date',
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Obx(() {
                            return TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "To",
                                labelStyle: const TextStyle(
                               //   color: Colors.black,
                                ),
                                hintText: 'Select Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () =>
                                      controller.pickToDate(context),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: NsdlInvestor360Colors.lightGrey7,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              controller: TextEditingController(
                                text: controller.selectedToDate.value != null
                                    ? DateFormat('dd MMM yyyy').format(
                                        controller.selectedToDate.value!,
                                      )
                                    : 'Select Date',
                              ),
                              onChanged: (value) {
                                controller.isDateError.value = false;
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.isDateError.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Custom Date Range Buttons
                    Wrap(
                      spacing: 8.0,
                      children: [
                        customDateRangeButton("Previous Day"),
                        customDateRangeButton("Last 7 Days"),
                        customDateRangeButton("Last 15 Days"),
                        customDateRangeButton("Last 30 Days"),
                      ],
                    ),
                    // const SizedBox(height: 16),
                    // Obx(() {
                    //   return Wrap(
                    //     spacing: 8.0,
                    //     children: customDateList.map((user) {
                    //       return FilterChip(
                    //         label: Text(user.name ?? ''),
                    //         selected:
                    //             controller.selectedCustomDateList.contains(user),
                    //         onSelected: (isSelected) {
                    //           //  controller.toggleSelection(user);
                    //         },
                    //       );
                    //     }).toList(),
                    //   );
                    // }),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Investor360Button(
                            onTap: () async {
                              if (controller.selectedFromDate.value == null &&
                                  controller.selectedToDate.value == null) {
                                controller.isDateError.value = true;
                                controller.errorMessage.value =
                                    "Please select dates";
                                return;
                              } else if (controller.selectedFromDate.value ==
                                  null) {
                                controller.isDateError.value = true;
                                controller.errorMessage.value =
                                    "Please select From date";
                                return;
                              } else if (controller.selectedToDate.value ==
                                  null) {
                                controller.isDateError.value = true;
                                controller.errorMessage.value =
                                    "Please select To date";
                                return;
                              } else {
                                controller.isDateError.value = false;
                                String fromDate =
                                    DateFormat('yyyy-MM-dd').format(
                                  controller.selectedFromDate.value!,
                                );
                                String toDate = DateFormat('yyyy-MM-dd').format(
                                  controller.selectedToDate.value!,
                                );

                                await controller.createSotFileAPI(
                                    fromDate,
                                    toDate,
                                    context,
                                    transactController.selectedClientId.value
                                        .toString(),
                                    transactController.selectedDpId.value
                                        .toString());
                              }
                            },
                            buttonText: "Generate Report")
                        //  ElevatedButton(
                        //     onPressed: () async {
                        //       String fromDate = DateFormat('yyyy-MM-dd').format(
                        //         controller.selectedFromDate.value,
                        //       );
                        //       String toDate = DateFormat('yyyy-MM-dd').format(
                        //         controller.selectedToDate.value,
                        //       );

                        //       await controller.createSotFileAPI(
                        //           fromDate,
                        //           toDate,
                        //           context,
                        //           transactController.selectedClientId.value
                        //               .toString(),
                        //           transactController.selectedDpId.value.toString());
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor:
                        //           NsdlInvestor360Colors.bottomCardHomeColour2,
                        //       minimumSize: const Size(double.infinity, 50),
                        //     ),
                        //     child: Text(
                        //       "Generate Report",
                        //       style: TextStyle(
                        //           fontSize: 16.5,
                        //           fontFamily: GoogleFonts.lato().fontFamily,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w500),
                        //     )),
                        ),
                    const SizedBox(height: 16),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'No, Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: NsdlInvestor360Colors.appblue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDateRangeButton(String label) {
    bool darkMode = ThemeUtils.isDarkMode(Get.context!);
    return Obx(() {
      bool isSelected = controller.selectedDateRange.value == label;
      return OutlinedButton(
        onPressed: () {
          controller.setCustomDateRange(label);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
          side: BorderSide(
              color: isSelected
                  ? NsdlInvestor360Colors.bottomCardHomeColour1
                  : Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: isSelected
              ? darkMode? NsdlInvestor360Colors.buttonDarkcolour :NsdlInvestor360Colors.bottomCardHomeColour2.withOpacity(1.0)
              : darkMode? Colors.white60 : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            color: isSelected ? NsdlInvestor360Colors.white : Colors.black,
          ),
        ),
      );
    });
  }
}
