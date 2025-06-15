import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/services_others/controller/update_email_bottomsheet_controller.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';

class UpdateEmailBottomSheet extends StatefulWidget {
  const UpdateEmailBottomSheet({super.key});

  @override
  State<UpdateEmailBottomSheet> createState() => _UpdateEmailBottomSheetState();
}

UpdateEmailBottomsheetController controller =
    Get.put(UpdateEmailBottomsheetController());

class _UpdateEmailBottomSheetState extends State<UpdateEmailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: darkMode
                  ? NsdlInvestor360Colors.darkmodeBlack
                  : NsdlInvestor360Colors.backLightBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 45),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Update Your Email ID',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Enter New Email ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: NsdlInvestor360Colors.lightGrey6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color:
                                    darkMode ? Colors.white : Color(0xFF222D40),
                              ), // Set label text color
                              hintText: 'Email',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: darkMode
                                      ? Colors.white60
                                      : Color(0xFF222D40),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: darkMode
                                        ? Colors.white60
                                        : Color(0xFF222D40)),
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
                          )),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Obx(() {
                            return controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      if (controller
                                              .emailController.text.isEmpty ||
                                          !controller
                                              .emailController.text.isEmail) {
                                        showSnackBar(context,
                                            "Please enter a valid Email Address");
                                      } else {
                                        controller.updateEmailAPI(
                                            "IN487875",
                                            "12055001",
                                            controller.emailController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: darkMode
                                          ? NsdlInvestor360Colors
                                              .buttonDarkcolour
                                          : NsdlInvestor360Colors
                                              .bottomCardHomeColour2,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                          })),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Color(0xFF2958FF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -35, // Adjust as needed to position the image correctly
          left: MediaQuery.of(context).size.width / 2 -
              35, // Center the image horizontally
          child: Container(
              height: 70, // Adjust the height as needed
              width: 70, // Adjust the width as needed
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: SvgPicture.asset(
                'assets/updateEmail.svg',
                height: 70,
                width: 70,
                fit: BoxFit.contain,
              )),
        ),
      ],
    );
  }
}
