import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PoweredBy extends StatelessWidget {
  final Color color;
  const PoweredBy(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Powered By",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.8,
              fontFamily: GoogleFonts.lato().fontFamily,
              color: color),
        ),
        const Padding(padding: EdgeInsets.only(left: 5)),
        SvgPicture.asset(
          'assets/nsdl-logo.svg',
          height: 50,
          width: 50,
        )
        // Image.asset('assets/nsdl-logo.png'),
        // const Padding(padding: EdgeInsets.only(left: 5)),
        // SvgPicture.asset(
        //   'assets/nsdl-text.svg',
        //   color: color,
        // ),
      ],
    );
  }
}
