import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/evoting/views/sort_bottomsheet_evoting.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/modules/evoting/controller/e_voting_controller.dart';
import 'package:investor360/modules/service_reports/views/service.dart';
import 'package:investor360/shared/style/colors.dart';

class Evoting extends StatefulWidget {
  const Evoting({super.key});

  @override
  State<Evoting> createState() => _EvotingState();
}

EvotingController controller = Get.put(EvotingController());
/*final List<VotingCycle> votingCycles = List.generate(
  17,
  (index) => VotingCycle(
    id: '1115000',
    companyName: 'TCS LIMITED',
    endDate: '20-Jul-2024',
  ),
);*/

class _EvotingState extends State<Evoting> {
  EvotingController evotingController = Get.put(EvotingController());

  @override
  void initState() {
    evotingController.getEvotingEventListApi();
    // evotingController.performComparison();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Service(selectedPage: 1),
          ),
        );
        return Future.value(false); // Return a Future<bool>
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
          elevation: 0.5,
          // shadowColor: Colors.white.withOpacity(0.6),
          title: Text(
            "E-Voting",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              // color: Colors.black,
              fontFamily: GoogleFonts.lato().fontFamily,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              //   color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Service(selectedPage: 1),
                ),
              );
            },
          ),
        ),
        body: Obx(() {
          if (evotingController.votingCycles.isEmpty) {
            return Center(child: Text('No voting cycles available'));
          }

          return Container(
            decoration: BoxDecoration(
                color: darkMode
                    ? NsdlInvestor360Colors.darkmodeBlack
                    : NsdlInvestor360Colors.backLightBlue),
            child: Column(
              children: [
                const SizedBox(height: 0),
                Container(
                  decoration: BoxDecoration(
                      color: darkMode
                          ? NsdlInvestor360Colors.darkmodeBlack
                          : NsdlInvestor360Colors.backLightBlue),
                  child: Container(
                    color:      darkMode ? NsdlInvestor360Colors.darkmodeBlack : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0), // Adjust padding if needed
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ACTIVE E-VOTING CYCLES",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? Colors.white
                                : Colors.black, // Text color based on mode
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(SortBottomSheetEvoting());
                          },
                          child: Row(
                            children: [
                              Text(
                                "Sort",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: darkMode
                                      ? Colors.white
                                      : Colors
                                          .black, // Text color based on mode
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Space between text and icon
                              Image.asset(
                                'assets/sort.png',
                                width: 20, // Adjust the width of the icon
                                height: 20, // Adjust the height of the icon
                                color: darkMode
                                    ? Colors.white
                                    : Colors.black, // Icon color based on mode
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: evotingController.combinedList
                        .length, // Make sure this matches the combinedList length
                    itemBuilder: (context, index) {
                      final combinedEvent =
                          evotingController.combinedList[index];
                      return VotingCycleCard(
                        totalPosition: combinedEvent.totalPosition,
                        company: combinedEvent.company,
                        espName: combinedEvent.issuerName.toString(),
                        dateEndCycle: combinedEvent.cycleEndDate,
                        dateEndEvent: combinedEvent.eventEndDate,
                        eventId: combinedEvent.evenId,
                        espCode: combinedEvent.espCode,
                        index: index,
                      );
                    },
                  ),
                ),

                /*  Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: evotingController.votingCycles.length,
                    itemBuilder: (context, index) {
                      final company =
                          evotingController.votingCycles[index].company;

                      return VotingCycleCard(
                        votingCycle: evotingController.votingCycles[index],
                        company: company ?? 'Unknown Company',
                        eventId: evotingController.votingCycles[index].evenId.toString() ,
                        index: index ,
                      );
                    },
                  ),
                ),*/

                //  const Divider(height: 2),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class VotingCycleCard extends StatelessWidget {
  final String company;
  final String espName;
  final String dateEndCycle;
  final String dateEndEvent;
  final String eventId;
  final String espCode;
  final int index;
  final double? totalPosition;

  VotingCycleCard({
    required this.company,
    required this.totalPosition,
    required this.espName,
    required this.dateEndCycle,
    required this.dateEndEvent,
    required this.eventId,
    required this.espCode,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          if (espCode.contains("1")) {
            controller.getEvotingEventResolutionListAPI(eventId, index);
          } else {
            print("espcodeis ${espCode}");
            controller.getEspUrlAPI(espCode, context);
          }
        },
        child: Card(
          color: darkMode
              ? NsdlInvestor360Colors.bottomCardHomeColour3Dark
              : NsdlInvestor360Colors.pureWhite,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        maxLines: 2,
                        company + espName,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
              /*      Text(
                      totalPosition != null
                          ? totalPosition.toString()
                          : 'No Position', // Display totalPosition or a fallback message
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),*/
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E-voting End Date',
                      style: TextStyle(
                          fontSize: 12.0,
                          color: darkMode ? Colors.white60 : Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      dateEndCycle + dateEndEvent,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
class VotingCycleCard extends StatelessWidget {
  //final VotingCycle votingCycle;
  final EventList votingCycle;
  final String company;
  final String eventId;
  final  int index;
/*  final String company;
  final String company;*/

  //const VotingCycleCard({super.key, required this.votingCycle});
  VotingCycleCard({required this.votingCycle, required this.company, required this.eventId, required  this.index});

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        controller.getEvotingEventResolutionListAPI(eventId,index);
      //  Get.toNamed(Routes.evotingDetail.name);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          color: darkMode
              ? NsdlInvestor360Colors.bottomCardHomeColour3Dark
              : NsdlInvestor360Colors.pureWhite,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      votingCycle.company.toString(),
                      //  votingCycle.cycleEndTime.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'E-voting End Date',
                      style: TextStyle(
                          fontSize: 12.0,
                          color: darkMode ? Colors.white60 : Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "",
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      votingCycle.cycleEndDate.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

class VotingCycle {
  final String id;
  final String companyName;
  final String endDate;

  VotingCycle({
    required this.id,
    required this.companyName,
    required this.endDate,
  });
}
