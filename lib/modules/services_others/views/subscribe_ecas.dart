import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/services_others/controller/subscribe_ecas_controller.dart';
import 'package:investor360/shared/style/colors.dart';

class SubcribeEcasScreen extends StatefulWidget {
  SubcribeEcasScreen({super.key});

  @override
  State<SubcribeEcasScreen> createState() => _SubcribeEcasScreenState();
}

class _SubcribeEcasScreenState extends State<SubcribeEcasScreen> {
  SubscribeEcasController controller = Get.put(SubscribeEcasController());

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF222D40),
        appBar: AppBar(
          backgroundColor: const Color(0xFF222D40),
          title: const Text(
            'Subscribe eCAS',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context)
                    .size
                    .height), // Forces the view to fill the entire height
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: SvgPicture.asset(
                      'assets/subscribe_background.svg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkMode
                            ? NsdlInvestor360Colors.darkmodeBlack
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Subscribe !",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Subscribe eCAS to get a better Understanding",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: darkMode
                                    ? Colors.white60
                                    : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              enabled: !controller.subscribed.value,
                              controller: controller.emailcontroller,
                              style: TextStyle(
                                color: darkMode
                                    ? Colors.white
                                    : const Color(0xFF222D40),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: darkMode
                                      ? Colors.white60
                                      : const Color(0xFF222D40),
                                ),
                                hintText: 'Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: darkMode
                                        ? Colors.white60
                                        : const Color(0xFF222D40),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: darkMode
                                        ? Colors.white60
                                        : const Color(0xFF222D40),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: controller.panController,
                              enabled: false,
                              style: TextStyle(
                                color: darkMode
                                    ? Colors.white
                                    : const Color(0xFF222D40),
                              ),
                              decoration: InputDecoration(
                                labelText: 'PAN',
                                labelStyle: TextStyle(
                                  color: darkMode
                                      ? Colors.white60
                                      : const Color(0xFF222D40),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: darkMode
                                        ? Colors.white60
                                        : const Color(0xFF222D40),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Obx(() {
                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return
                                      // Investor360Button(
                                      //   onTap: () async {
                                      //     controller.subscribeEcasApi(
                                      //         "IN487875", "12055001");
                                      //   },
                                      //   buttonText: "Subscribe",
                                      // );
                                      ElevatedButton(
                                    onPressed: controller.subscribed.value
                                        ? null // Disable the button if subscribed
                                        : () async {
                                            controller.subscribeEcasApi(
                                                "IN487875", "12055001");
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                              .subscribed.value
                                          ? Colors
                                              .grey // Change the color when disabled
                                          : (darkMode
                                              ? NsdlInvestor360Colors
                                                  .buttonDarkcolour
                                              : NsdlInvestor360Colors
                                                  .bottomCardHomeColour2),
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    child: Text(
                                      controller.subscribed.value
                                          ? "Subscribed"
                                          : "Subscribe",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
