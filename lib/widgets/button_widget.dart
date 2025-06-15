// custom_elevated_button.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';

class Investor360Button extends StatelessWidget {
  final Future<void> Function() onTap;
  final String buttonText;
  final bool isSmallButton;
  final bool isEnabled;

  const Investor360Button({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isSmallButton = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return ElevatedButton(
      onPressed: isEnabled
          ? () async {
              await onTap();
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? darkMode
                ? NsdlInvestor360Colors.buttonDarkcolour
                : NsdlInvestor360Colors.bottomCardHomeColour2
            : NsdlInvestor360Colors.lightGrey12,
        padding: isSmallButton
            ? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0)
            : null,
        minimumSize:
            isSmallButton ? const Size(0, 30) : const Size(double.infinity, 50),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: isSmallButton ? 14 : 18,
          fontFamily: GoogleFonts.lato().fontFamily,
          color: Colors.white,
          fontWeight: isSmallButton ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}
