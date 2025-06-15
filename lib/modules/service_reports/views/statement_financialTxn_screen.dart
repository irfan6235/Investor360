import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/controller/soft_controller.dart';
import 'package:investor360/modules/service_reports/model/getSftFileListResponse.dart';
import 'package:investor360/widgets/button_widget.dart';

import '../../../shared/style/colors.dart';

class StatementFinancialTxnScreen extends StatefulWidget {
  const StatementFinancialTxnScreen({super.key});

  @override
  State<StatementFinancialTxnScreen> createState() =>
      _StatementFinancialTxnScreenState();
}

class _StatementFinancialTxnScreenState
    extends State<StatementFinancialTxnScreen> {
  SoftController controller = Get.put(SoftController());
  // bool showDataReport = false;
  final BottomSheetSftController bottomController =
      Get.put(BottomSheetSftController());

  // void toggleReport() {
  //   setState(() {
  //     showDataReport = !showDataReport;
  //   });
  // }

  // @override
  // void initState() {
  //   // controller.fetchDropdownData();
  //   // controller.generatesftfile();

  //   controller.initializeData();
  //   bottomController.resetSelection();
  //   super.initState();
  // }

  @override
  void initState() {
    controller.initializeData();
    controller.initializeDownloadedFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return RefreshIndicator(
      onRefresh: () async {
        controller.initializeData();
        controller.initializeDownloadedFiles();
      },
      child: Scaffold(
        backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        appBar: AppBar(
          backgroundColor: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.pureWhite,
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "Statement of Financial Txn",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
          //    color: Colors.black,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
         //     color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color:    darkMode? NsdlInvestor360Colors.bottomCardHomeColour3Dark :NsdlInvestor360Colors.backLightBlue,
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          SftBottomSheet(),
                          isScrollControlled: true,
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 100),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 100),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              controller.dpId_clientId.value =
                                  value["dpId_clientId"];
                              controller.textEditingControllerSft.text =
                                  value["dpId_clientId"] ?? "";
                              print('Selected: $value');
                            });
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2),
                        child: SizedBox(
                          height: 50,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextField(
                              controller: controller.textEditingControllerSft,
                              decoration: InputDecoration(
                                labelText: "Demat Account",
                                labelStyle: const TextStyle(
                             //     color: Colors.black,
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
                                hintText: "All",
                                hintStyle: TextStyle(
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontSize: 18,
                               //   color: Colors.black,
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down_sharp,
                              //    color: Colors.black,
                                ),
                              ),
                              style: const TextStyle(
                            //    color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return dataReport(controller.reportItems);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Widget noReportView() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Image.asset(
  //         'assets/client.png',
  //       ),
  //       const SizedBox(height: 10),
  //       Text(
  //         "No Reports",
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: GoogleFonts.lato().fontFamily,
  //         ),
  //       ),
  //       Text(
  //         'Click on the "Generate Report" button to view\n all available reports in the system.',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           fontFamily: GoogleFonts.lato().fontFamily,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //       const SizedBox(height: 20),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 35, right: 35),
  //         child: ElevatedButton(
  //           onPressed: toggleReport,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
  //             minimumSize: const Size(double.infinity, 50),
  //           ),
  //           child: Text(
  //             "Generate Report",
  //             style: TextStyle(
  //               fontSize: 16.5,
  //               fontFamily: GoogleFonts.lato().fontFamily,
  //               color: Colors.white,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat outputFormat = DateFormat("dd MMM yyyy hh:mma");
    String formattedDate = outputFormat.format(dateTime);
    formattedDate = formattedDate.replaceAll("AM", "AM").replaceAll("PM", "PM");
    return formattedDate;
  }

  String _getStatus(int? status) {
    switch (status) {
      case 200:
        return 'Completed';
      case 102:
        return 'In-Progress';
      case 103:
        return 'Failed';
      case 104:
        return 'No Transaction Found';
      // case 400:
      //   return 'Rejected';
      // case 100:
      //   return 'In-progress';
      default:
        return 'In-Progress';
    }
  }

  Widget dataReport(List<GetSftFileListResponseItem> reports) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: DropdownButtonFormField<String>(
            value: controller.selectedFile.value,
            decoration: InputDecoration(
              labelText: 'Select Quarter',
              labelStyle: const TextStyle(/*color: Colors.grey[700]*/),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedFile.value = newValue;
                print("Selected File: $newValue"); // Print the selected file
                // controller.updateSelectedFullKey(); // Update selectedFullKey
              }
            },
            items: controller.monthYear
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "REPORT HISTORY",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Investor360Button(
                  onTap: () async {
                    controller.generatesftfile(context);
                  },
                  buttonText: "Generate Report",
                  isSmallButton: true,
                )
                // ElevatedButton(
                //   onPressed: () {
                //     controller.generatesftfile(context);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 0.0, horizontal: 20.0),
                //     minimumSize: const Size(
                //         0, 30), // Adjust these values to match the image
                //   ),
                //   child: Text(
                //     "Generate Report",
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontFamily: GoogleFonts.lato().fontFamily,
                //       color: Colors.white,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                ),
          ],
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Divider(height: 1, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            '*Note - Downloaded file password is your PAN Number in capital letters.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Obx(() {
            if (controller.reportItems.isEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 90),
                    Image.asset('assets/client.png'),
                    const SizedBox(height: 10),
                    Text(
                      "No Reports",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                    ),
                    Text(
                      'Click on the "Generate Report" button to view\n all available reports in the system.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, right: 35),
                            child: ElevatedButton(
                              onPressed: () {
                                // controller.createCMrFileAPI(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    NsdlInvestor360Colors.bottomCardHomeColour2,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(
                                "Generate Report",
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]);
            } else {
              print("Length of Item = ${controller.reportItems.length}");
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.reportItems.length,
                itemBuilder: (context, index) {
                  var item = controller.reportItems[index];
                  controller.fileIsDownloaded.value =
                      controller.downloadedFiles.contains(item.fileId);

                  return ReportItem(
                    date:
                        formatDateString(item.requestedTime ?? 'Unknown Date'),
                    status: _getStatus(item.status),
                    downloadable: item.status == 200,
                    fileId: item.fileId ?? '', // Pass the fileId
                    onDownload: () {
                      print("file Id is " + item.fileId!);

                      setState(() {});
                      controller.getSoftFileAPI(item.fileId!);
                      //  widget.controller.downloadFile(item.fileId ?? '');
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }
}

class ReportItem extends StatelessWidget {
  final String date;
  final String status;
  final bool downloadable;
  final String fileId;
  final VoidCallback? onDownload;

  const ReportItem({
    Key? key,
    required this.date,
    required this.status,
    this.downloadable = false,
    required this.fileId,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SoftController controller = Get.put(SoftController());
    Color statusColor;
    switch (status) {
      case 'In-Progress':
        statusColor = Colors.orange;
        break;
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'Failed':
        statusColor = Colors.red;
        break;
      case 'No Transaction Found':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    bool darkMode = ThemeUtils.isDarkMode(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
        color: darkMode? NsdlInvestor360Colors.bottomCardHomeColour3Dark : NsdlInvestor360Colors.pureWhite,
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/pdf.svg'),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
                Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (downloadable)
            Obx(() {
              bool isFileDownloaded =
                  controller.downloadedFiles.contains(fileId);
              return InkWell(
                onTap: onDownload,
                child: isFileDownloaded
                    ? Icon(Icons.open_in_new_outlined,
                    color:  darkMode? NsdlInvestor360Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2)
                    : SvgPicture.asset('assets/download.svg',color:  darkMode? NsdlInvestor360Colors.white : NsdlInvestor360Colors.bottomCardHomeColour2),
              );
            }),
        ],
      ),
    );
  }
}
