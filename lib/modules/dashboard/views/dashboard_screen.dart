import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/portfolio/controller/PortfolioController.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';

import 'package:investor360/modules/portfolio/screens/portfolio.dart';
import 'package:investor360/modules/evoting/controller/e_voting_controller.dart';

import 'package:investor360/utils/formatnumber.dart';
import 'package:investor360/modules/drawer/views/custom_drawer.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../routes/routes.dart';
import '../../../shared/style/colors.dart';
import '../../../widgets/custom_bottom_navigation.dart';
import '../../../widgets/custom_toobar.dart';

import 'beneid_bottomsheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());
  final EvotingController evotingController = Get.put(EvotingController());
  late PortfolioController portfolioController =
      Get.find<PortfolioController>();

  final BottomSheetController controllerBottomSheet =
      Get.put(BottomSheetController());

  bool isAmountFull = false;

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    List<String> assetNames = ["Equity", "Mutual Funds", "Debt", "Others"];

    List<Color> colorListAssetAllocation2 = [
      NsdlInvestor360Colors.pieBlueColor2,
      NsdlInvestor360Colors.pieClayColor2,
      NsdlInvestor360Colors.pieYellowColor2,
      NsdlInvestor360Colors.piePinkColor2
    ];

    List<Color> colorListAssetAllocation1 = [
      NsdlInvestor360Colors.pieBlueColor,
      NsdlInvestor360Colors.pieClayColor,
      NsdlInvestor360Colors.pieYellowColor,
      NsdlInvestor360Colors.piePinkColor
    ];

    List<Color> colorListSectorComp = [
      NsdlInvestor360Colors.pieSectorBlueColor,
      NsdlInvestor360Colors.pieSectorDarkPinkColor,
      NsdlInvestor360Colors.pieSectorYellowColor,
      NsdlInvestor360Colors.pieSectorPinkColor,
      NsdlInvestor360Colors.pieSectorGreenColor,
    ];

    bool isLoading = false;
    Map<String, double> dataMapSectorComp = {
      //   controller.businessSectorText.value:44,
      'Pharmaceuticals': 34,
      'Finance & Investments': 60,
      'IT Services & \nConsulting ': 20,
      'Consumer Electronics\n & Appliances': 45,
      'Life Insurance': 55,
    };

    int _selectedSectorIndex = -1; // no selection

    final _advancedDrawerController = AdvancedDrawerController();

    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (controller.responseData.value != null) {
            /*   Map<String, BusinessSectorValue> businessSectorData =
                controller.calculateBusinessSectorTotalValue(controller.responseData.value!.holdingDataList);*/

            // Convert businessSectorData to a list of SectorComposition objects
            List<SectorComposition> sectorDataList = controller
                .businessSectorTotalValues.entries
                .map((entry) => SectorComposition(entry.key,
                    entry.value.totalValue, entry.value.additionalValue))
                .toList();

            List<Color> colorList = controller.generateBaseColors(
                controller.businessSectorTotalValues.length);
            //  List<Color> colorList2 = controller.generateDarkerColors(colorList);

            /*  List<Color> colorList =
                    controller.generateColorsnew(businessSectorData.length);
                List<Color> colorList2 =
                    controller.generateColorsnew2(businessSectorData.length);*/

            List<double> assetValues = [
              controller.equityValue.value,
              controller.mFValue.value,
              controller.deptValue.value,
              controller.othersValue.value
            ];
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AdvancedDrawer(
                //   openScale: 0.8,
                backdrop: Container(
                  decoration:  const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/drawerAbstract.png'),
                      fit: BoxFit.fitWidth,
                      //  opacity: 0.1,
                      alignment: Alignment.topLeft,
                    ),
                    gradient: LinearGradient(
                      colors:
                    /*  darkMode ? [
                      NsdlInvestor360Colors.bottomCardHomeColour2Dark,
                      NsdlInvestor360Colors.bottomCardHomeColour0,
                      ] :*/
                      [
                        NsdlInvestor360Colors.bottomCardHomeColour2,
                        NsdlInvestor360Colors.bottomCardHomeColour0,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                backdropColor: Colors.transparent,
                // backdropColor: NsdlInvestor360Colors.drawerColor,
                controller: _advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                animateChildDecoration: true,
                rtlOpening: false,
                disabledGestures: false,
                childDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(44)),
                  boxShadow: [
                    BoxShadow(
                      color: NsdlInvestor360Colors.drowShodowDrawerColor,
                      //blurStyle: BlurStyle.solid,
                      blurRadius: 1.0, // Softness of the shadow
                      spreadRadius: -90.0, // Extent of the shadow
                      offset:
                          Offset(-140, -10), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                drawer: CustomDrawer(
                  advancedDrawerController: _advancedDrawerController,
                ),
                child: Scaffold(
                  backgroundColor:  darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
                  appBar: CustomAppBar(
                      advancedDrawerController: _advancedDrawerController),

                  //  appBar: CustomAppBar(),
                  // drawer: CustomDrawer(),

                  body: Stack(
                    children: [
                      SingleChildScrollView(
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
                                        MyBottomSheet(),
                                        isScrollControlled: true,
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 100),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 100),
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            controller.dpId_clientId.value =
                                                value["dpId_clientId"];
                                            controller
                                                    .textEditingControllerBeneid
                                                    .text =
                                                value["dpId_clientId"] ?? "";
                                            print('Selected: $value');
                                          });
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 2),
                                      child: SizedBox(
                                        height: 50,
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextField(
                                            controller: controller
                                                .textEditingControllerBeneid,
                                            decoration: InputDecoration(
                                              labelText: "Demat Account",
                                              labelStyle: TextStyle(
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(16),
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: NsdlInvestor360Colors
                                                      .lightGrey7,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: NsdlInvestor360Colors
                                                      .lightGrey7,
                                                  width: 1.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: NsdlInvestor360Colors
                                                      .lightGrey7,
                                                  width: 1.0,
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: NsdlInvestor360Colors
                                                      .lightGrey7,
                                                  width: 1.0,
                                                ),
                                              ),
                                              hintText: "All",
                                              hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.roboto()
                                                    .fontFamily,
                                                fontSize: 18,
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              suffixIcon: Icon(
                                                Icons.arrow_drop_down_sharp,
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            style:  TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 5, left: 16, right: 16),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "OVERALL VALUE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Market Value",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.2,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily,
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // Aligns widgets to the extreme corners
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              //    highlightColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  isAmountFull = !isAmountFull;
                                                });
                                              },
                                              child: Text(
                                                !isAmountFull
                                                    ? formatNumber(double.parse(
                                                        controller.totalValue
                                                            .toString()))
                                                    : "\u20B9${formatNumberWithCommas(double.parse(controller.totalValue.toStringAsFixed(2)))}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 33.5,
                                                  fontFamily: GoogleFonts.lato()
                                                      .fontFamily,
                                                  color: darkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              controllerBottomSheet
                                                  .resetSelection();
                                              controller
                                                  .textEditingControllerBeneid
                                                  .text = 'All';
                                              await controller
                                                  .fetchNsdlHoldingDataApi();
                                            },
                                            child: Container(
                                              height: 39,
                                              width: 39,
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              child:
                                              darkMode ?
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
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            //  Asset alloction

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                // Adjust the border radius as needed
                                color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.backLightBlue,
                                /*  border: Border(
                                top: BorderSide(
                                  color: Colors.black, // Specify border color
                                  width: 0.1, // Specify border width
                                ),
                              ),*/
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "ASSET ALLOCATION",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: controller.dataMap.isNotEmpty
                                              ? pie_chart.PieChart(
                                                  dataMap: controller.dataMap,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 4000),
                                                  chartLegendSpacing: 32,
                                                  chartRadius:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3.5,
                                                  colorList:
                                                      colorListAssetAllocation2,
                                                  initialAngleInDegree: 0,
                                                  chartType:
                                                      pie_chart.ChartType.ring,
                                                  ringStrokeWidth: 48,
                                                  centerText: "",
                                                  legendOptions: const pie_chart
                                                      .LegendOptions(
                                                    showLegendsInRow: false,
                                                    legendPosition: pie_chart
                                                        .LegendPosition.bottom,
                                                    showLegends: false,
                                                    legendShape:
                                                        BoxShape.circle,
                                                    legendTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.6,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  chartValuesOptions:
                                                      const pie_chart
                                                          .ChartValuesOptions(
                                                    showChartValueBackground:
                                                        true,
                                                    showChartValues: false,
                                                    showChartValuesInPercentage:
                                                        true,
                                                    showChartValuesOutside:
                                                        true,
                                                    decimalPlaces: 1,
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                      'No data available')),
                                        ),
                                        Center(
                                          child: controller.dataMap.isNotEmpty
                                              ? pie_chart.PieChart(
                                                  dataMap: controller.dataMap,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 4000),
                                                  chartLegendSpacing: 32,
                                                  chartRadius:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3.2,
                                                  colorList:
                                                      colorListAssetAllocation1,
                                                  initialAngleInDegree: 0,
                                                  chartType:
                                                      pie_chart.ChartType.ring,
                                                  ringStrokeWidth: 40,
                                                  centerText: "",
                                                  legendOptions:
                                                      pie_chart.LegendOptions(
                                                    showLegendsInRow: true,
                                                    legendPosition: pie_chart
                                                        .LegendPosition.bottom,
                                                    showLegends: true,
                                                    legendShape:
                                                        BoxShape.circle,
                                                    legendTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.0,
                                                      color: darkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  chartValuesOptions:
                                                      const pie_chart
                                                          .ChartValuesOptions(
                                                    showChartValueBackground:
                                                        true,
                                                    showChartValues: false,
                                                    showChartValuesInPercentage:
                                                        true,
                                                    showChartValuesOutside:
                                                        true,
                                                    decimalPlaces: 1,
                                                  ),
                                                )
                                              : Center(child: Text(' ')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //sector comp
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 16,
                                      right: 16,
                                      bottom: 1),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "SECTOR COMPOSITION",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Visibility(
                                          visible: false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Wrap(
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons.switch_left,
                                                        size: 10),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Investment",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.7,
                                                        fontFamily:
                                                            GoogleFonts.lato()
                                                                .fontFamily,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10.0,
                                    top: 1,
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              height: 210,
                                              child: sectorDataList != null &&
                                                      sectorDataList.isNotEmpty
                                                  ? SfCircularChart(
                                                      legend: Legend(
                                                        position: LegendPosition
                                                            .bottom,
                                                        orientation:
                                                            LegendItemOrientation
                                                                .vertical,
                                                        shouldAlwaysShowScrollbar:
                                                            true,
                                                        isVisible: false,
                                                        overflowMode:
                                                            LegendItemOverflowMode
                                                                .wrap,
                                                      ),
                                                      tooltipBehavior:
                                                          TooltipBehavior(
                                                        enable: true,
                                                        duration: 4000,
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        format:
                                                            'Value: point.x \nWeight: point.y%',
                                                      ),
                                                      series: <CircularSeries<
                                                          SectorComposition,
                                                          dynamic>>[
                                                        DoughnutSeries<
                                                            SectorComposition,
                                                            dynamic>(
                                                          dataSource:
                                                              sectorDataList,
                                                          animationDuration:
                                                              4000,
                                                          xValueMapper:
                                                              (SectorComposition
                                                                          data,
                                                                      _) =>
                                                                  formatNumber(
                                                                      data.valuee),
                                                          yValueMapper:
                                                              (SectorComposition
                                                                          data,
                                                                      _) =>
                                                                  data.weight,
                                                          pointColorMapper:
                                                              (SectorComposition
                                                                      data,
                                                                  _) {
                                                            int index = sectorDataList
                                                                .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .name ==
                                                                        data.name);
                                                            return colorList[
                                                                index];
                                                          },
                                                          dataLabelSettings:
                                                              const DataLabelSettings(
                                                            isVisible: false,
                                                          ),
                                                          // enableSmartLabels: true,
                                                          enableTooltip: true,
                                                          explode: true,
                                                          explodeAll: false,
                                                          explodeIndex: 0,
                                                          explodeOffset: '10%',
                                                          radius: '90%',
                                                          innerRadius: '45%',
                                                        ),
                                                      ],
                                                      // Enable 3D effect
                                                      enableMultiSelection:
                                                          true,
                                                      // enableSideBySideSeriesPlacement: true,
                                                      borderWidth: 2,
                                                      borderColor:
                                                          Colors.transparent,
                                                      annotations: <CircularChartAnnotation>[
                                                        CircularChartAnnotation(
                                                          widget: Container(
                                                            child: const Text(
                                                              '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          'No data available')),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        height:
                                            120, // Adjust the height as needed
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // Align children to the bottom
                                          children: [
                                            Expanded(
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                  itemCount: controller
                                                      .businessSectorTotalValues
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var entry = controller
                                                        .businessSectorTotalValues
                                                        .entries
                                                        .toList()[index];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      child: Row(
                                                        children: [
                                                          legendItem(
                                                              entry.key,
                                                              colorList[controller
                                                                  .businessSectorTotalValues
                                                                  .entries
                                                                  .toList()
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .key ==
                                                                      entry
                                                                          .key)],
                                                              "${entry.value.additionalValue.toStringAsFixed(2)}%"),
                                                        ],
                                                      ),
                                                    );
                                                  },
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

                            //grid data in list
                            Container(
                              decoration:  BoxDecoration(
                                color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.backLightBlue,

                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22.0,
                                        top: 20,
                                        bottom: 10,
                                        right: 22),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "QUICK PORTFOLIO",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Visibility(
                                              visible: false,
                                              child: Text(
                                                "Top funds for your consideration",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      GoogleFonts.roboto()
                                                          .fontFamily,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => PortfolioScreen(
                                                selectedPage: 0));
                                          },
                                          child: Text(
                                            "View all",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              fontFamily: GoogleFonts.roboto()
                                                  .fontFamily,
                                              color: NsdlInvestor360Colors
                                                  .appMainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  assetValues != null &&
                                          assetValues.any((value) => value != 0)
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(4, (index) {
                                              if (assetValues[index] == 0) {
                                                return Container();
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      12.0),
                                                  width: 270,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        NsdlInvestor360Colors
                                                            .bottomCardHomeColour1,
                                                        NsdlInvestor360Colors
                                                            .bottomCardHomeColour2
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      stops: [0.6, 0.4],
                                                    ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          PortfolioScreen(
                                                              selectedPage:
                                                                  index));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 14.0,
                                                                  right: 14,
                                                                  top: 12,
                                                                  bottom: 12),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    assetNames[
                                                                        index],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15.3,
                                                                      fontFamily:
                                                                          GoogleFonts.lato()
                                                                              .fontFamily,
                                                                      color: NsdlInvestor360Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    formatNumber(
                                                                        double.parse(
                                                                            assetValues[index].toString())),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          16.6,
                                                                      fontFamily:
                                                                          GoogleFonts.lato()
                                                                              .fontFamily,
                                                                      color: NsdlInvestor360Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  "MARKET VALUE",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        12.8,
                                                                    fontFamily:
                                                                        GoogleFonts.lato()
                                                                            .fontFamily,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16.0,
                                                                  right: 16,
                                                                  bottom: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Holdings",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      14.8,
                                                                  fontFamily: GoogleFonts
                                                                          .lato()
                                                                      .fontFamily,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(
                                              top: 14.0, bottom: 20),
                                          child: Center(
                                              child: Text('No data available')),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: CustomBottomNavigationBar(
                    currentIndex: 0,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          Get.toNamed(Routes.dashboardScreen.name);
                          break;
                        case 1:
                          Get.toNamed(Routes.portfolio.name);
                          break;
                        case 2:
                          Get.toNamed(Routes.account.name);
                          break;
                        case 3:
                          Get.toNamed(Routes.market.name);
                          break;
                        case 4:
                          Get.toNamed(Routes.services.name);
                          break;
                      }
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: SizedBox());
          }
        },
      ),

      /*        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              // Define the default text style for unselected labels here
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: TextStyle(color: NsdlInvestor360Colors.grey),
                  ),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset('assets/selectedhome.png',
                      width: 22, height: 22),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon:
                      Image.asset('assets/portfolio.png', width: 22, height: 22),
                  label: 'Portfolio',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/market.png', width: 22, height: 22),
                  label: 'Market',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/transact.png', width: 22, height: 22),
                  label: 'Transacts',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/more.png', width: 22, height: 22),
                  label: 'More',
                ),
              ],
              currentIndex: 0,
              selectedItemColor: NsdlInvestor360Colors.appMainColor,
              unselectedItemColor: NsdlInvestor360Colors.grey,
              selectedLabelStyle: TextStyle(
                color: NsdlInvestor360Colors.appMainColor,
                fontWeight: FontWeight.w800,
                fontSize: 11.9,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
              unselectedLabelStyle: TextStyle(
                color: NsdlInvestor360Colors.grey,
                fontWeight: FontWeight.w800,
                fontSize: 11.9,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
              //   onTap: _onItemTapped,
            ),
          ),*/
    );
  }

  @override
  void initState() {
    super.initState();
    controller.textEditingControllerBeneid = TextEditingController();
    controller.textEditingControllerBeneid.clear();

    if (!controller.isBottomSheetShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        evotingController.showEvotingBottomSheet();
        controller.isBottomSheetShown = true;
      });
    }
    //controller.fetchNsdlHoldingDataApi();
    controllerBottomSheet.selectedIndex.value = null;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadDataIfNeeded();
    });
  }

  Future<void> loadDataIfNeeded() async {
    controller.filterHoldingsByDPIDAndClientID("ALL", "ALL");
    if (!controller.isDashboardDataLoaded.value) {
      //  await controller.fetchNsdlHoldingDataApi();
    }
  }

  @override
  void dispose() {
    controllerBottomSheet.selectedIndex.value = null;
    super.dispose();
  }

  Widget _buildItem(String text, String imageData, String weight) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageData,
              scale: 0.9,
            ),
            const SizedBox(height: 5),
            Text(
              "Value",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11.6,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.grey,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12.2,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Weight",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11.6,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.grey,
              ),
            ),
            Text(
              weight,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12.2,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

/*  void resetAllControllers() {
    Get.reset();
  }

  void clearControllerState() {
    // controller.reset();
  }

  void disposeController() {
    controller.dispose();
  }*/

/*  Widget legendItem(String label, Color color, String weight) {
    return Row(
      mainAxisSize: MainAxisSize.max, // Ensure the row takes up minimum horizontal space
      crossAxisAlignment: CrossAxisAlignment.center, // Align text vertically with colored box
      children: [
        ClipRRect(
          borderRadius:
          BorderRadius.circular(2), // Adjust border radius as needed
          child: Container(
            width: 18, // Adjust width as needed
            height: 18, // Adjust height as needed
            color: color, // Use the provided color
          ),
        ),
        const SizedBox(
            width: 5), // Adjust spacing between color and label as needed
        Container(
          // decoration: BoxDecoration(color: Colors.red),
          width: 350,
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.8, // Adjust font size as needed
                  color: Colors.black, // Use your preferred color
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    weight,
                    style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.8, // Adjust font size as needed
                      color: Colors.black, // Use your preferred color
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }*/

  Widget legendItem(String label, Color color, String weight) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(2), // Adjust border radius as needed
              child: Container(
                width: 18, // Adjust width as needed
                height: 18, // Adjust height as needed
                color: color, // Use the provided color
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.8, // Adjust font size as needed
                  color: darkMode
                      ? Colors.white
                      : Colors.black, // Use your preferred color
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              weight,
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 13.8, // Adjust font size as needed
                color: darkMode
                    ? Colors.white
                    : Colors.black, // Use your preferred color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectorComposition {
  SectorComposition(this.name, this.valuee, this.weight);

  final String name;
  final double valuee;
  final double weight;
}
