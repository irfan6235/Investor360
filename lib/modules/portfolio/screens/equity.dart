import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/portfolio/controller/PortfolioController.dart';
import 'package:investor360/modules/portfolio/screens/holding_details_screen.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/portfolio/screens/portfolio_beneid_bottomsheet.dart';
import 'package:investor360/modules/portfolio/screens/sort_bottom_sheet.dart';

import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/formatnumber.dart';

import 'info_cart_security_type.dart';

class Equity extends StatefulWidget {
  const Equity({super.key});

  @override
  EquityState createState() => EquityState();
}

class EquityState extends State<Equity> {
  final PortfolioController portfolioController =
      Get.find<PortfolioController>();
  final BottomSheetPortfolioController controllerBottomSheet =
      Get.put(BottomSheetPortfolioController());

  @override
  void initState() {
    super.initState();
    portfolioController.textEditingControllerBeneidEquity =
        TextEditingController();
    portfolioController.textEditingControllerBeneidEquity.clear();
    controllerBottomSheet.resetSelection();
    portfolioController.searchBarEquityController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    portfolioController.textEditingControllerBeneidEquity.text = 'All';

    //   portfolioController.filterHoldingsByDPIDAndClientID("ALL", "ALL", "EQUITY");
    // portfolioController.fetchNsdlHoldingDataApiPortfolio();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadDataIfNeeded();
    });
  }

  Future<void> loadDataIfNeeded() async {
    portfolioController.filterHoldingsByDPIDAndClientID("ALL", "ALL", "EQUITY");
    if (!portfolioController.isEquityDataLoaded.value) {
      //     await portfolioController.fetchNsdlHoldingDataApiPortfolio();
    }
  }

  @override
  void dispose() {
    controllerBottomSheet.selectedIndex.value = null;
    super.dispose();
  }

  /*
  void searchFilterHoldings(String query) {
    // setState(() {
    portfolioController.filteredHoldings.value = portfolioController
        .responseData.value!.holdingDataList!
        .where((holding) {
      final companyName = holding.companyName.toLowerCase();
      return companyName.contains(query.toLowerCase());
    }).toList();
    //   });
  }*/

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Obx(() {
      if (portfolioController.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (portfolioController.responseData.value == null) {
        return const Center(child: Text('No data available'));
      } else {
        List<HoldingDataList> equityHoldings = portfolioController
            .filteredHoldings
            .where((holding) => holding.securityType == "EQUITY")
            .toList();

        return Scaffold(
          backgroundColor:darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
               color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.backLightBlue,

                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            MyBottomSheetPortfolio("EQUITY"),
                            isScrollControlled: true,
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 100),
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 100),
                          ).then((value) {
                            if (value != null) {
                              //   setState(() {
                              //   dashboardController.dpId_clientId.value = value["dpId_clientId_equity"];
                              portfolioController
                                  .textEditingControllerBeneidEquity
                                  .text = value["dpId_clientId"] ?? "";
                              portfolioController.searchBarEquityController
                                  .clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                              print('Selected: ${value["dpId_clientId"]}');
                              //  });
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 2),
                          child: SizedBox(
                            height: 50,
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextField(
                                controller: portfolioController
                                    .textEditingControllerBeneidEquity,
                                decoration: InputDecoration(
                                  labelText: "Demat Account",
                                  labelStyle:  TextStyle(
                                    color: darkMode?  Colors.white : Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                      width: 1.0,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: "All",
                                  hintStyle: TextStyle(
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  suffixIcon:  Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: darkMode?  Colors.white : Colors.black,
                                  ),
                                ),
                                style:  TextStyle(
                                  color: darkMode?  Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "MARKET VALUE",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.8,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatNumber(portfolioController
                                    .equityValuePortfolio.value),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color:darkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      controllerBottomSheet.resetSelection();
                                      portfolioController
                                          .searchBarEquityController
                                          .clear();
                                      FocusScope.of(context).unfocus();
                                      portfolioController
                                          .textEditingControllerBeneidEquity
                                          .text = 'All';
                                      await portfolioController
                                          .fetchNsdlHoldingDataApiPortfolio();
                                    },
                                    child: Container(
                                      height: 39,
                                      width: 39,
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child:  darkMode ?
                                      SvgPicture.asset(
                                        'assets/refreshbtnwhite.svg',
                                      )
                                          :

                                      SvgPicture.asset(
                                        'assets/refreshbtn.svg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration:  BoxDecoration(
                    color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.backLightBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                             Text(
                              "HOLDINGS",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:  darkMode ? Colors.white :  Colors.black
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  SortBottomSheet(portfolioController
                                      .filteredHoldings.value),
                                  isScrollControlled: true,
                                  enterBottomSheetDuration:
                                      const Duration(milliseconds: 100),
                                  exitBottomSheetDuration:
                                      const Duration(milliseconds: 100),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      print('Selected: $value');
                                    });
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "Sort",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  Image.asset('assets/sort.png',color: darkMode? Colors.white: Colors.black,)
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: TextStyle(
                                  color: darkMode ? Colors.white : Colors.black,),
                                controller: portfolioController
                                    .searchBarEquityController,
                                onChanged:
                                    portfolioController.searchFilterHoldings,
                                cursorColor: NsdlInvestor360Colors.lightGrey7,
                                decoration: InputDecoration(
                                  fillColor: darkMode? NsdlInvestor360Colors.darkmodeBlack: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors.lightGrey7,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                      color: NsdlInvestor360Colors
                                          .bottomCardHomeColour0,
                                    ),
                                  ),
                                  hintText: 'Search by company name',
                                  hintStyle: TextStyle(
                                    color: darkMode? NsdlInvestor360Colors.white: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: equityHoldings.length,
                          itemBuilder: (context, index) {
                            final item = equityHoldings[index];
                            if (item.securityType == "EQUITY") {
                              return GestureDetector(
                                onTap: () {
                                  print(equityHoldings[index].isin);
                                  Get.to(() => HoldingDetail(
                                        selectedIndexHolding: index,
                                        securityType: "EQUITY",
                                      ));
                                },
                                child: InfoCardSecurityType(
                                  companyName: item.companyName,
                                  quantity: formatNumberWithCommasHoldinDetails(
                                      double.parse(
                                          item.totalPosition.toString())),
                                  totalMarketVal: formatNumber(
                                      double.parse(item.totalValue)),
                                ),
                              );
                              /*    return InfoCardSecurityType(
                                companyName: item.companyName,
                                quantity: item.totalPosition.toString(),
                                totalMarketVal: formatNumber(
                                    double.parse(item.totalValue)),
                              );*/
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  /*@override
  void dispose() {
    portfolioController.resetValues();
    super.dispose();
  }
*/
}
