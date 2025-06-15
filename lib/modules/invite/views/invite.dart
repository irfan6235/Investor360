import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/widgets/button_widget.dart';
import 'package:share_plus/share_plus.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(Routes.dashboardScreen.name);
        return false;
      },
      child: Scaffold(
        backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        appBar: AppBar(
          backgroundColor: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.pureWhite,
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "Invite",
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
              // Navigator.of(context).pop();
              Get.toNamed(Routes.dashboardScreen.name);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/invite.png',
              ),
            ),
            Text(
              "Invite your Friends",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: darkMode? Colors.white :Colors.black87,
              ),
            ),
            Text(
              "“Coz your friends deserve to\nLive Life Better”",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: Investor360Button(
                  onTap: () async {
                    const String text = "Check out this app!";
                    const String subject = "Investor360";
                    Share.share(text, subject: subject);
                  },
                  buttonText: "Invite Now"),
              // ElevatedButton(
              //     onPressed: () async {
              //       const String text = "Check out this app!";
              //       const String subject = "Investor360";
              //       Share.share(text, subject: subject);
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //           NsdlInvestor360Colors.bottomCardHomeColour2,
              //       minimumSize: const Size(double.infinity, 50),
              //     ),
              //     child: Text(
              //       "Invite Now",
              //       style: TextStyle(
              //           fontSize: 16.5,
              //           fontFamily: GoogleFonts.lato().fontFamily,
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500),
              //     )),
            )
          ],
        ),
      ),
    );
  }
}
