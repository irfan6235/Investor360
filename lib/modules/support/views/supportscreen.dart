import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch $email');
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      print('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(Routes.dashboardScreen.name);
        return false;
      },
      child: Scaffold(
        backgroundColor:     darkMode ? NsdlInvestor360Colors.darkmodeBlack: Colors.white,
        appBar: AppBar(
          backgroundColor: darkMode ? NsdlInvestor360Colors.darkmodeBlack: NsdlInvestor360Colors.pureWhite,
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "Support",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkMode ? Colors.white: Colors.black,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
          leading: IconButton(
            icon:  Icon(
              Icons.arrow_back,
              color: darkMode ? Colors.white: Colors.black,
            ),
            onPressed: () {
              Get.toNamed(Routes.dashboardScreen.name);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "CONTACT DETAILS",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                  height: 1, color: NsdlInvestor360Colors.lightestgrey3),
              const SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.w400,
                  color: NsdlInvestor360Colors.lightGrey6,
                ),
              ),
              GestureDetector(
                onTap: () => _launchEmail("mobileappfeedback@nsdl.com"),
                child: Text(
                  "mobileappfeedback@nsdl.com",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Contact Number",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.w400,
                  color: NsdlInvestor360Colors.lightGrey6,
                ),
              ),
              GestureDetector(
                onTap: () => _launchPhone("022-48867000"),
                child: Text(
                  "022-48867000",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _launchPhone("022-24997000"),
                child: Text(
                  "022-24997000",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Divider(
                  height: 1, color: NsdlInvestor360Colors.lightestgrey3),
              const SizedBox(height: 30),
              Text(
                "Need help with something else?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.7,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  color:   darkMode ? Colors.grey: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: Investor360Button(
                      onTap: () async {}, buttonText: "Chat with us")

                  // ElevatedButton(
                  //   onPressed: () async {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor:
                  //         NsdlInvestor360Colors.bottomCardHomeColour2,
                  //     minimumSize: const Size(double.infinity, 50),
                  //   ),
                  //   child: Text(
                  //     "Chat with us",
                  //     style: TextStyle(
                  //       fontSize: 16.5,
                  //       fontFamily: GoogleFonts.lato().fontFamily,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
