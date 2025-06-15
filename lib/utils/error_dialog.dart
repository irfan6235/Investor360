import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/shared/style/colors.dart';

import '../shared/components/button_design.dart';


class ErrorDialog extends StatelessWidget {
  final String message;
  final bool isExpired;
  const ErrorDialog({Key? key, required this.message, required this.isExpired}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), //this right here
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(8),
                    topStart: Radius.circular(8)),
                color: NsdlInvestor360Colors.logintopbar,
              ),
              child:  Image.asset('assets/logo.png',
                color: NsdlInvestor360Colors.appMainColor,
                height: 27,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 8),
                    child: Text(message,
                      style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: NsdlInvestor360Colors.darkgrey),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: ButtonBodyUpi(
                            onPressed: () {
                              if(isExpired) {
                                /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    const Login()), (Route<dynamic> route) => false);*/
                              } else {
                                Get.back();
                              }
                            },
                            textBlack: true,
                            labelText: "OK",
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
