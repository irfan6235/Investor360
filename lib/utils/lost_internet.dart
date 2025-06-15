import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/widgets/button_widget.dart';
//import 'package:lottie/lottie.dart';

import '../shared/style/colors.dart';

class InternetDownPage extends StatefulWidget {
  const InternetDownPage({Key? key}) : super(key: key);

  @override
  State<InternetDownPage> createState() => _InternetDownPageState();
}

class _InternetDownPageState extends State<InternetDownPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                SizedBox(
                  height: Get.height / 20,
                ),
             //   Lottie.asset('resources/assets/lottie/no.json'),
              ]),
              Column(
                children: [
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                        color: NsdlInvestor360Colors.darkyellow, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Your device is currently not connected to the internet, please check your internet connectivity and try again.',
                    style: TextStyle(
                        color: NsdlInvestor360Colors.black, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height / 16,
                  ),
                  Investor360Button(
                      onTap: () async {
                        final connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.none) {
                          Get.back();
                        }
                      },
                      buttonText: "Try Again")

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final connectivityResult =
                  //     await (Connectivity().checkConnectivity());
                  //     if (connectivityResult != ConnectivityResult.none) {
                  //       Get.back();
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor:
                  //     NsdlInvestor360Colors.bottomCardHomeColour2,
                  //     minimumSize: const Size(double.infinity, 50),
                  //   ),
                  //   child: const Text(
                  //     "Try Again",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
