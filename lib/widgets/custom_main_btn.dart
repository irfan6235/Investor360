import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/shared/style/decoration.dart';

import '../shared/style/colors.dart';

class CustomMainButton extends StatelessWidget {
  CustomMainButton({
    this.labelText,
    this.onPressed,
    this.child, // Add child here
  });

  final String? labelText;
  final void Function()? onPressed;
  final Widget? child; // Declare child property

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
/*      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecoration(NsdlInvestor360Decorations.btnDisable)
          : NsdlInvestor360Decorations.btnDecoration(NsdlInvestor360Decorations.btnColorLightGrey),*/
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
          minimumSize: const Size(double.infinity, 50),),
         child: Text(
              labelText!,
              style: TextStyle(
                fontSize: 16.5,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    );
  }
}


