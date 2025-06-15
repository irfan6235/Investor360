import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/string_constants.dart';

class InfoCardSecurityType extends StatelessWidget {
  final String companyName;
  final String quantity;
  final String totalMarketVal;

  const InfoCardSecurityType({
    super.key,
    required this.companyName,
    required this.quantity,
    required this.totalMarketVal,
  });

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color:  darkMode? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        elevation: 0.5,
        child: ListTile(
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                color: darkMode? NsdlInvestor360Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
              children: [
                TextSpan(
                    text: '$companyName\n',
                    style:  TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: darkMode? NsdlInvestor360Colors.white : Colors.black,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    )),
                TextSpan(
                  text: "Qty. $quantity",
                  style:  TextStyle(
                    color: darkMode? NsdlInvestor360Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                     /*TextSpan(
                      text: '\u20B9',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize:
                        14.0, // Increase the size of the currency symbol
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                    TextSpan(
                      text: totalMarketVal,
                      style:  TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                       // fontFamily: StringConstants.kCustomFontFamily,
                        color: darkMode? NsdlInvestor360Colors.white : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
               Text(
                'Market Value',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}