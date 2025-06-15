import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/controller/cmr_controller.dart';
import 'package:investor360/modules/service_reports/controller/services_bottomsheet.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/modules/service_reports/model/getCmrListResponse.dart';
import 'package:investor360/widgets/button_widget.dart';

import '../controller/statement_transact_controller.dart';

class ClientMasterReport extends StatefulWidget {
  const ClientMasterReport({super.key});

  @override
  ClientMasterReportState createState() => ClientMasterReportState();
}

class ClientMasterReportState extends State<ClientMasterReport> {
  final CmrCoontroller controller = Get.put(CmrCoontroller());

  @override
  void initState() {
    super.initState();
    controller.initializeData();
    controller.initializeDownloadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return RefreshIndicator(
      onRefresh: () async {
        print("Refresh triggered");
        controller.initializeData();
        await controller.initializeDownloadedFiles();
        print("Refresh complete");
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.pureWhite,
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "Client Master Report",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkMode? Colors.white :Colors.black,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
          leading: IconButton(
            icon:  Icon(
              Icons.arrow_back,
              color: darkMode? Colors.white :Colors.black,
            ),
            onPressed: () {
              Get.toNamed(Routes.services.name);
            },
          ),
        ),
        body: ListView(
          children: [
            Container(
              color:    darkMode? NsdlInvestor360Colors.bottomCardHomeColour3Dark :NsdlInvestor360Colors.backLightBlue,
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        CMRBottomSheet(),
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
                            controller.textEditingControllerBeneidCMR.text =
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
                            controller:
                                controller.textEditingControllerBeneidCMR,
                            decoration: InputDecoration(
                              labelText: "Demat Account",
                              labelStyle:  TextStyle(
                                color: darkMode? Colors.white :Colors.black,
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
                                color: darkMode? Colors.white :Colors.black,
                              ),
                              suffixIcon:  Icon(
                                Icons.arrow_drop_down_sharp,
                                color: darkMode? Colors.white :Colors.black,
                              ),
                            ),
                            style:  TextStyle(
                              color: darkMode? Colors.white :Colors.black,
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
                // return noReportView();
              }
            }),
          ],
        ),
      ),
    );
  }

  // Widget noReportView() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       const SizedBox(height: 90),
  //       Center(child: Image.asset('assets/client.png')),
  //       const SizedBox(height: 10),
  //       Text(
  //         "No Reports",
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: GoogleFonts.lato().fontFamily,
  //         ),
  //       ),
  //       Visibility(
  //         visible: false,
  //         child: Column(
  //           children: [
  //             Text(
  //               'Click on the "Generate Report" button to view\n all available reports in the system.',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //                 fontFamily: GoogleFonts.lato().fontFamily,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 20),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 35, right: 35),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   controller.createCMrFileAPI(context);
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor:
  //                       NsdlInvestor360Colors.bottomCardHomeColour2,
  //                   minimumSize: const Size(double.infinity, 50),
  //                 ),
  //                 child: Text(
  //                   "Generate Report",
  //                   style: TextStyle(
  //                     fontSize: 16.5,
  //                     fontFamily: GoogleFonts.lato().fontFamily,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget dataReport(List<GetCmrListResponseItem> reports) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Container(
      color: darkMode?  NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.white,
      child: Column(
        children: [
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
                      controller.createCMrFileAPI(context);
                    },
                    buttonText: "Generate Report",
                    isSmallButton: true,
                  )
                  // ElevatedButton(
                  //   onPressed: () {
                  //     controller.createCMrFileAPI(context);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 0.0, horizontal: 20.0),
                  //     minimumSize: const Size(0, 30),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Note - Password is your PAN in capital letters.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Obx(() {
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
              return SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    var item = reports[index];
                    controller.fileIsDownloaded.value =
                        controller.downloadedFiles.contains(item.fileId);

                    return ReportItem(
                      date:
                          formatDateString(item.requestedTime ?? 'Unknown Date'),
                      status: _getStatus(item.status),
                      downloadable: item.status == 200,
                      fileId: item.fileId ?? '',
                      onDownload: () {
                        controller.getCmrFileAPI(fileId: item.fileId ?? '');
                      },
                    );
                  },
                ),
              );
            }
          }),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height - 300,
          //   child: ListView.builder(
          //     itemCount: reports.length,
          //     itemBuilder: (context, index) {
          //       var item = reports[index];
          //       return ReportItem(
          //         date: formatDateString(item.requestedTime ?? 'Unknown Date'),
          //         status: _getStatus(item.status),
          //         downloadable: item.status == 200,
          //         fileId: item.fileId ?? '',
          //         onDownload: (String fileId) {
          //           controller.getCmrFileAPI(fileId: fileId);
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

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
    required this.downloadable,
    required this.fileId,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CmrCoontroller controller = Get.put(CmrCoontroller());
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

          /*  InkWell(
              onTap: () {
                onDownload?.call(fileId);
              },
              child: controller.isDownloaded.value
                  ? SvgPicture.asset('assets/download.svg') : SvgPicture.asset('assets/download.svg'),
                //  ? SvgPicture.asset('assets/download.svg') : Icon(Icons.file_open_rounded, color: NsdlInvestor360Colors.redPdf,),
            ),*/
        ],
      ),
    );
  }
}
