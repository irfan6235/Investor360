import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/components/button_design.dart';
import '../../../shared/style/colors.dart';

class Investor360CommonDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonTap;
  VoidCallback? onLeftTap;
  String? title;
  String? leftBtnText;

  Investor360CommonDialog({
    Key? key,
    required this.message,
    required this.buttonText,
    this.title,
    this.onLeftTap,
    this.leftBtnText,
    required this.onButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(8),
                topStart: Radius.circular(8),
              ),
              color: Color(0xfffaf5df),
            ),
            child: SizedBox(
              height: 25,
              child: Image.asset('assets/logo.png')
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: title != null,
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: NsdlInvestor360Colors.dark_grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: onLeftTap != null,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.34,
                        height: 52,
                        child: ButtonBodyOutlinedDialog(
                          onPressed: onLeftTap,
                          labelText: leftBtnText,
                          isDisable: false,
                          textBlack: true,
                          isTextFitted: true,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width *0.34,
                        child: ButtonBodyUpi(
                          onPressed: onButtonTap,
                          textBlack: true,
                          labelText: buttonText,
                        ),
                      ),
                    ],
                  ),
                ),
                onLeftTap != null
                    ? const SizedBox()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ButtonBodyUpi(
                          onPressed: onButtonTap,
                          textBlack: true,
                          labelText: buttonText,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
