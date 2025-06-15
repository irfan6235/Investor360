import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/service_reports/views/service.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';

class EcasServices extends StatelessWidget {
  const EcasServices({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Service(selectedPage: 2),
          ),
        );
        return Future.value(false); // Return a Future<bool>
      },
      child: Scaffold(
        backgroundColor: darkMode
            ? NsdlInvestor360Colors.darkmodeBlack
            : NsdlInvestor360Colors.backLightBlue,
        appBar: AppBar(
          backgroundColor: darkMode
              ? NsdlInvestor360Colors.darkmodeBlack
              : NsdlInvestor360Colors.pureWhite,
          title: const Text(
            'eCAS Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Service(selectedPage: 2),
                ),
              );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Update Email ID Section
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.emailUpdate.name);
                },
                child: Material(
                  elevation: 4, // Set the desired elevation
                  borderRadius:
                      BorderRadius.circular(10), // Match border radius
                  shadowColor: Colors.grey
                      .withOpacity(0.5), // Optional: Adjust shadow color
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // White border color
                        width: 0.6, // Border width
                      ),
                      color: darkMode
                          ? NsdlInvestor360Colors.bottomCardHomeColour2
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(10), // Circular border
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Update Email ID ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.trackEcas.name);
                },
                child: Material(
                  elevation: 4, // Set the desired elevation
                  borderRadius:
                      BorderRadius.circular(10), // Match border radius
                  shadowColor: Colors.grey
                      .withOpacity(0.5), // Optional: Adjust shadow color
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // White border color
                        width: 0.6, // Border width
                      ),
                      color: darkMode
                          ? NsdlInvestor360Colors.bottomCardHomeColour2
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(10), // Circular border
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Track Your eCas",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
