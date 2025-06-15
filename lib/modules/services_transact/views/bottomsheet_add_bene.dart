import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/services_transact/controller/add_bene_controller.dart';
import 'package:investor360/modules/services_transact/controller/beneficiary_details_controller.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AddBeneBottomSheetVerify extends StatefulWidget {
  AddBeneBottomSheetVerify({super.key, required this.called});
  final String called;

  @override
  State<AddBeneBottomSheetVerify> createState() =>
      _AddBeneBottomSheetVerifyState();
}

class _AddBeneBottomSheetVerifyState extends State<AddBeneBottomSheetVerify> {
  final AddBeneController controller = Get.put(AddBeneController());

  TextEditingController pin = TextEditingController();

  String textForvalidate = "";

  bool validateOTPField(BuildContext context) {
    if (pin.text.length == 6 && widget.called == "Delete") {
      controller.validateOTPAddBeneficiaryApi(pin, context, "Delete");
      return true;
    } else if (pin.text.length == 6 && widget.called == "Add") {
      controller.validateOTPAddBeneficiaryApi(pin, context, "Add");
      return true;
    } else {
      showErrorDialog("Enter Valid OTP", context);
      return false;
    }
  }

  @override
  void initState() {
    if (widget.called == "Delete") {
      textForvalidate = "Deletion";
    } else {
      textForvalidate = "Addition";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // This ensures the image can overflow the Stack
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
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
                  padding: const EdgeInsets.only(left: 16.0, right: 16,bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: textForvalidate == "Addition",
                        child: const Column(
                          children: [
                            Center(
                              child: Text(
                                "Great!",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          'Validate OTP',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: Text(
                          'We have sent you an OTP on your \nregistered mobile number\nfor Beneficiary $textForvalidate.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: NsdlInvestor360Colors.lightGrey6,
                          ),
                        ),
                      ),
                      //ENter OTP Text
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter OTP",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: PinCodeTextField(
                          keyboardType: TextInputType.number,
                          controller: pin,
                          appContext: context,
                          length: 6,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            inactiveColor: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            validateOTPField(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                NsdlInvestor360Colors.bottomCardHomeColour2,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Validate",
                            style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Did not receive OTP?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 3),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Resend",
                                style: TextStyle(
                                  color: NsdlInvestor360Colors.appblue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
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
            child: textForvalidate == "Deletion"
                ? SvgPicture.asset(
                    'assets/del.svg',
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(
                    'assets/verify.svg',
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ],
    );
  }
}

class AddBeneBottomSheetNotFound extends StatelessWidget {
  final AddBeneController controller = Get.put(AddBeneController());

  AddBeneBottomSheetNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // This ensures the image can overflow the Stack
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 45),
                const Center(
                  child: Text(
                    "Oops!",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Account Not Found',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: Text(
                          "The system couldn't find the relevant \naccount. Please try again by entering the\ncorrect information.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: NsdlInvestor360Colors.lightGrey6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                NsdlInvestor360Colors.bottomCardHomeColour2,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 16.5,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50)
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
              'assets/oops.svg',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class AddBeneBottomSheetDelete extends StatelessWidget {
  final AddBeneController controller = Get.put(AddBeneController());
  final BeneficiaryDetailsController beneDetailcontroller =
      Get.put(BeneficiaryDetailsController());
  AddBeneBottomSheetDelete(
      {super.key,
      required this.type,
      required this.dpId_clientId,
      required this.dpId,
      required this.clientId,
      required this.pan});
  final String type;
  final String dpId_clientId;
  final String dpId;
  final String clientId;
  final String pan;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25), // Adjusted for image overlap

                      Center(
                        child: Text(
                          'Confirmation',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Are you sure you want to delete\nthis entry ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  color: NsdlInvestor360Colors.lightGrey6,
                                ),
                              ),
                              TextSpan(
                                text: "($dpId_clientId)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                              TextSpan(
                                text: "?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (type == "NSDL") {
                              beneDetailcontroller.deleteNsdlBeneficiaryAPI(
                                  dpId, clientId, pan, context);
                            } else {
                              beneDetailcontroller.deleteNonNsdlBeneficiaryAPI(
                                  dpId_clientId, pan, context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                NsdlInvestor360Colors.bottomCardHomeColour2,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Yes, Delete",
                            style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text(
                            "No, Cancel",
                            style: TextStyle(
                              color: NsdlInvestor360Colors.appblue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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
              'assets/del.svg',
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
