import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/services_others/controller/ecas_service_controller.dart';
import 'package:investor360/modules/services_others/controller/track_ecas_controller.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/widgets/button_widget.dart';

class TrackEcas extends StatefulWidget {
  const TrackEcas({super.key});

  @override
  State<TrackEcas> createState() => _TrackEcasState();
}

class _TrackEcasState extends State<TrackEcas> {
  final EcasServicesController ecasServicesController =
      Get.put(EcasServicesController());
  final TrackEcasController controller = Get.put(TrackEcasController());

  RxList<String> months = <String>[].obs;

  @override
  void initState() {
    super.initState();
    controller.getEcasDetailsApi("IN487875", "12055001");
    // Set the initial year and filtered months
    controller.selectedYear1?.value = ecasServicesController.getYears().first;
    months.value = ecasServicesController
        .getFilteredMonths(int.parse(controller.selectedYear1?.value ?? '0'));
    controller.selectedMonth?.value =
        months.isNotEmpty ? months.first : ''; // Set initial month
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.ecasServices.name);
        return Future.value(false); // Return a Future<bool>
      },
      child: Scaffold(
        backgroundColor: darkMode
            ? NsdlInvestor360Colors.darkmodeBlack
            : NsdlInvestor360Colors.backLightBlue,
        appBar: AppBar(
          backgroundColor: darkMode
              ? NsdlInvestor360Colors.darkmodeBlack
              : NsdlInvestor360Colors.pureWhite,
          title: const Text(
            'eCAS Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Get.back();
              Get.toNamed(Routes.ecasServices.name);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Update Email ID Section
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.emailUpdate.name);
                    },
                    child: Material(
                      elevation: 5, // This adds elevation (shadow)
                      borderRadius: BorderRadius.circular(
                          10), // This ensures the Material has rounded corners
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // White border color
                            width: 0.6, // Border width
                          ),
                          color: darkMode
                              ? NsdlInvestor360Colors.bottomCardHomeColour2
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(10), // Circular border
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Update Email ID",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),

              const SizedBox(height: 32),

              // Track Your eCAS Section
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    elevation: 5, // Adds elevation (shadow)
                    borderRadius: BorderRadius.circular(
                        10), // Ensures Material has rounded corners
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // White border color
                          width: 0.6, // Border width
                        ),
                        color: darkMode
                            ? NsdlInvestor360Colors.bottomCardHomeColour2
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(10), // Circular border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Track Your eCAS',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Divider(
                              height: 1,
                              color: NsdlInvestor360Colors.lightGrey4,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller.emailController,
                              enabled: false, // This disables the TextField
                              style: TextStyle(
                                color:
                                    darkMode ? Colors.white : Color(0xFF222D40),
                              ), // Set text color
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: darkMode
                                      ? Colors.white60
                                      : Color(0xFF222D40),
                                ), // Set label text color
                                hintText: 'Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  //  borderSide: BorderSide(color: Color(0xFF222D40)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  //  borderSide: BorderSide(color: Color(0xFF222D40)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: darkMode
                                          ? Colors.white60
                                          : Color(0xFF222D40)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Year Dropdown wrapped with Obx
                            Obx(() {
                              return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Year',
                                  border: OutlineInputBorder(),
                                ),
                                value: controller.selectedYear1?.value,
                                items: ecasServicesController
                                    .getYears()
                                    .map((String year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  controller.selectedYear1?.value =
                                      newValue ?? '';
                                  months.value = ecasServicesController
                                      .getFilteredMonths(int.parse(
                                          controller.selectedYear1!.value));
                                  controller.selectedMonth?.value =
                                      months.isNotEmpty ? months.first : '';
                                },
                              );
                            }),

                            const SizedBox(height: 16),

                            // Month Dropdown wrapped with Obx
                            Obx(() {
                              return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Month',
                                  border: OutlineInputBorder(),
                                ),
                                value: controller.selectedMonth?.value,
                                items: months.map((String month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(month),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  controller.selectedMonth?.value =
                                      newValue ?? '';
                                },
                              );
                            }),

                            const SizedBox(height: 32),

                            // Track Button
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Investor360Button(
                                  onTap: () async {
                                    controller.trackEcasRequest(
                                        controller.emailController.text);
                                  },
                                  buttonText: "Track",
                                );
                              }
                            }),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
