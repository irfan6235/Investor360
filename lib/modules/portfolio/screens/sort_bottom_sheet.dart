import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';

import '../../../shared/style/colors.dart';
import '../../dashboard/model/GetNsdlHoldingDataResponse.dart';

class SortBottomSheet extends StatelessWidget {
  // final SortBottomSheetController controller = Get.put(SortBottomSheetController());
  List<HoldingDataList> filteredHoldings;

  SortBottomSheet(this.filteredHoldings);


  void sortHoldingsByMarketValueDesending() {
    filteredHoldings.sort((a, b) => double.parse(b.totalValue).compareTo(double.parse(a.totalValue)));
  }

/*  void sortHoldingsByComanyNameAtoZ() {
    filteredHoldings.sort((a, b) => a.companyName.compareTo(b.companyName));
  }*/

  void sortHoldingsByComanyNameAtoZ() {
    filteredHoldings.sort((a, b) => a.companyName.toLowerCase().compareTo(b.companyName.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Container(
      decoration:  BoxDecoration(
        color:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
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
              buildSortItem("High to Low", () {
                printSelectedText("High to Low");
                Get.back(result: "High to Low");
                sortHoldingsByMarketValueDesending();
              }),
              const Divider(
                indent: 10,
                endIndent: 10,
                color: NsdlInvestor360Colors.lightGrey8,
              ),
              buildSortItem("Company (A-Z)", () {
                printSelectedText("Company (A-Z)");
                Get.back(result: "Company (A-Z)");
                sortHoldingsByComanyNameAtoZ();
              }),
              SizedBox(height: 20,)
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
             // color: Colors.black,
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