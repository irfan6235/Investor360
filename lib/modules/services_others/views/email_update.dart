import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/services_others/controller/update_email_bottomsheet_controller.dart';
import 'package:investor360/modules/services_others/views/update_email_bottomsheet.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';

class EmailUpdate extends StatefulWidget {
  const EmailUpdate({super.key});

  @override
  State<EmailUpdate> createState() => _EmailUpdateState();
}

UpdateEmailBottomsheetController controller =
    Get.put(UpdateEmailBottomsheetController());

class _EmailUpdateState extends State<EmailUpdate> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.ecasServices.name);
        return Future.value(false);
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
              Get.toNamed(Routes.ecasServices.name);
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 0.6,
                          ),
                          color: darkMode
                              ? NsdlInvestor360Colors.bottomCardHomeColour2
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Update Email ID ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(
                                height: 1,
                                color: NsdlInvestor360Colors.lightGrey4,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w400,
                                    color: darkMode
                                        ? Colors.white60
                                        : NsdlInvestor360Colors.textColour,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Wrap only this Text in Obx since it's reactive
                                    Obx(() {
                                      return Text(
                                        controller.emaill.value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      );
                                    }),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Get.bottomSheet(
                                            const UpdateEmailBottomSheet());
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.trackEcas.name);
                        },
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 0.6,
                              ),
                              color: darkMode
                                  ? NsdlInvestor360Colors.bottomCardHomeColour2
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Track Your eCas",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Wrap only the loader in Obx
            Obx(() {
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox
                      .shrink(); // Return an empty widget when not loading
            }),
          ],
        ),
      ),
    );
  }
}
