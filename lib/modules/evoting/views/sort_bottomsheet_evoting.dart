import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Assuming GetX is being used
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/modules/evoting/controller/e_voting_controller.dart'; // Import your EvotingController

class SortBottomSheetEvoting extends StatelessWidget {
  final EvotingController evotingController = Get.find<EvotingController>();

  SortBottomSheetEvoting();
  void sortByTotalPosition() {
    evotingController.combinedList
        .sort((a, b) => (b.totalPosition ?? 0).compareTo(a.totalPosition ?? 0));
    for (var event in evotingController.combinedList) {
      print(event.toString());
    }
  }

  void sortEvotingsByEndDateDesending() {
    evotingController.combinedList.sort((a, b) {
      int eventComparison = b.eventEndDate.compareTo(a.eventEndDate);
      if (eventComparison != 0) {
        return eventComparison;
      } else {
        return b.cycleEndDate.compareTo(a.cycleEndDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'SORT BY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.6,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
          ),
          Column(
            children: [
              buildSortItem("E-voting End Date", () {
                printSelectedText("E-voting End Date");
                Get.back(result: "E-voting End Date");
                sortEvotingsByEndDateDesending();
              }),
              const Divider(
                indent: 10,
                endIndent: 10,
                color: NsdlInvestor360Colors.lightGrey8,
              ),
              buildSortItem("Security", () {
                sortByTotalPosition();
                printSelectedText("Security");
                Get.back();
              }),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSortItem(String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 7, bottom: 20),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.1,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  void printSelectedText(String text) {
    print("Selected: $text");
  }
}
