import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/evoting/controller/e_voting_controller.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/widgets/button_widget.dart';

class EvotingDetails extends StatefulWidget {
  const EvotingDetails({super.key});

  @override
  State<EvotingDetails> createState() => _EvotingDetailsState();
}

DashboardController dashboardController = Get.put(DashboardController());

EvotingController controller = Get.put(EvotingController());
List<HoldingDataList> displayHoldingDataList = dashboardController.shareee;
int maxvotes = 0;

class _EvotingDetailsState extends State<EvotingDetails> {
  int index = 0;
  bool isVoteAllowed = true;
  // List<int?> selectedValues = [];
  // List<int> logArray = []; // This will store 1 for the first option, 2 for other options
  // Track TextField controllers for votes cast
  // List<TextEditingController> votesCastControllers = [];

  @override
  void initState() {
    index = Get.arguments['index'];
    // Initialize selectedValues to have the same length as evotingResolutionListData and all null or default values
    controller.selectedValues =
        List<int?>.filled(controller.evotingResolutionListData.length, null);
    controller.logArray = List<int>.filled(
        controller.evotingResolutionListData.length, 0); // Initialize log array

    /*  votesCastControllers = List.generate(
     controller.evotingResolutionListData.length,
         (index) => TextEditingController(
       text: double.parse(controller.votingCycles[index].votesAllowed.toString()).toInt().toString(),
     ),
   );*/

    controller.votesCastControllers = List.generate(
      controller.evotingResolutionListData.length <
              controller.votingCycles.length
          ? controller.evotingResolutionListData.length
          : controller.votingCycles.length,
      (index) => TextEditingController(
          // text:
          //     double.parse(controller.votingCycles[index].votesAllowed.toString())
          //         .toInt()
          //         .toString(),
          ),
    );

    calculateAllowedVotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222D40),
        title: const Text(
          'E-Voting',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.toNamed(Routes.eVoting.name);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: darkMode
              ? NsdlInvestor360Colors.darkmodeBlack
              : NsdlInvestor360Colors.backLightBlue,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xFF222D40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index < controller.votingCycles.length
                            ? controller.votingCycles[index].company.toString()
                            : 'No Data Available', // Fallback if index is out of bounds
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: NsdlInvestor360Colors.pureWhite),
                      ),
                      /* Text(
                          controller.votingCycles[index].company.toString(),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: NsdlInvestor360Colors.pureWhite),
                        ),*/
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ISIN ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          Text(
                            index < controller.votingCycles.length
                                ? controller.votingCycles[index].isin.toString()
                                : 'No ISIN Available', // Fallback message or handling
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const DottedLine(
                        dashColor: Color(0xFF3B4960),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Record Date',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          Text(
                            index < controller.votingCycles.length
                                ? controller.votingCycles[index].recordDate
                                    .toString()
                                : 'No Record Date', // Fallback message if index is out of bounds
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          /* Text(
                              controller.votingCycles[index].recordDate.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xFF91A1BC)),
                            ),*/
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Voting End Date',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          Text(
                            index < controller.votingCycles.length
                                ? controller.votingCycles[index].cycleEndDate
                                    .toString()
                                : 'No Cycle End Date Available',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Max Vote Allowed',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          Builder(
                            builder: (context) {
                              double maxVoteAllowed =
                                  index < controller.votingCycles.length
                                      ? double.parse(controller
                                          .votingCycles[index].votesAllowed
                                          .toString())
                                      : 0;

                              String isin =
                                  index < controller.votingCycles.length
                                      ? controller.votingCycles[index].isin
                                          .toString()
                                      : '';

                              // Find matching holding data
                              var matchingHolding =
                                  displayHoldingDataList.firstWhere(
                                (holding) => holding.isin == isin,
                                orElse: () =>
                                    HoldingDataList(isin: '', totalPosition: 0),
                              );

                              double displayedMaxVote = matchingHolding != null
                                  ? maxVoteAllowed *
                                      matchingHolding.totalPosition
                                  : 0;
                              maxvotes = displayedMaxVote.toInt();
                              print("the max vote allowed is " +
                                  displayedMaxVote.toInt().toString());

                              return Text(
                                displayedMaxVote.toInt().toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF91A1BC)),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Result Date',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                          Text(
                            index < controller.votingCycles.length
                                ? controller.votingCycles[index].resultDate
                                    .toString()
                                : 'No Result Date Available', // Fallback if index is out of bounds
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF91A1BC)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.evotingResolutionListData.length,
                itemBuilder: (context, index) {
                  //  int allowedVotes = index < controller.votingCycles.length
                  //     ? (int.tryParse(controller
                  //                     .votingCycles[index].votesAllowed
                  //                     ?.toString() ??
                  //                 '0') ??
                  //             0) -
                  //         (int.tryParse(controller
                  //                     .evotingResolutionListData[index]
                  //                     .votesCast
                  //                     ?.toString() ??
                  //                 '0') ??
                  //             0)
                  //     : 0;
                  // //  int allowedVotes = 1;
                  // isVoteAllowed = allowedVotes > 0;

                  print("the maxvote coming in the allowed vote is" +
                      maxvotes.toString());
                  int allowedVotes = index < controller.votingCycles.length
                      ? maxvotes -
                          (int.tryParse(controller
                                      .evotingResolutionListData[index]
                                      .votesCast
                                      ?.toString() ??
                                  '0') ??
                              0)
                      : 0;
                  //  int allowedVotes = 1;
                  bool isVoteAllowed = allowedVotes > 0;

                  return Card(
                    color: darkMode
                        ? NsdlInvestor360Colors.darkmodeBlack
                        : isVoteAllowed
                            ? Colors.white
                            : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '${controller.evotingResolutionListData[index].resolutionName}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: darkMode
                                          ? Colors.white
                                          : NsdlInvestor360Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_sharp,
                                  color: darkMode
                                      ? Colors.white
                                      : NsdlInvestor360Colors.dark_grey,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              ' ${controller.evotingResolutionListData[index].resolutionDescription}',
                              style: TextStyle(
                                  color: darkMode
                                      ? Colors.white
                                      : NsdlInvestor360Colors.dark_grey,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500),
                            ),
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              // Handle resolution click
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Number of Votes to Cast (maximum $allowedVotes allowed)',
                            style: TextStyle(
                              fontSize: 12,
                              color: darkMode ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: index <
                                    controller.votesCastControllers.length
                                ? controller.votesCastControllers[index]
                                : null, // Provide null if the index is out of bounds
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            keyboardType: TextInputType.number,
                            enabled:
                                isVoteAllowed, // Disable if no votes are allowed
                            inputFormatters: [
                              OnlyDigitsInputFormatter(),
                              MaxVoteInputFormatter(
                                  allowedVotes), // Custom formatter
                            ],
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            itemCount: controller
                                .evotingResolutionListData[index]
                                .optionsArray!
                                .length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, optionIndex) {
                              return ListTile(
                                title: Text(
                                  controller.evotingResolutionListData[index]
                                      .optionsArray![optionIndex].optionName
                                      .toString(),
                                  style: TextStyle(
                                    color:
                                        darkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                leading: Radio<int>(
                                  value:
                                      optionIndex, // Assign the index as the value for each radio button
                                  groupValue: controller.selectedValues[
                                      index], // GroupValue is the currently selected value
                                  onChanged: isVoteAllowed
                                      ? (int? value) {
                                          setState(() {
                                            controller.selectedValues[index] =
                                                value;
                                            if (value == 0) {
                                              controller.logArray[index] =
                                                  1; // 1st option selected
                                            } else {
                                              controller.logArray[index] =
                                                  2; // Other options selected
                                            }
                                          });
                                        }
                                      : null, // Disable Radio button if no votes are allowed
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              //////////////
              /////////////
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Investor360Button(
                  isEnabled: isVoteAllowed,
                  onTap: isVoteAllowed
                      ? () async {
                          // Check if at least one option is selected
                          if (controller.selectedValues == null ||
                              controller.selectedValues.isEmpty ||
                              controller.selectedValues
                                  .every((element) => element == null)) {
                            showSnackBar(context,
                                "Please select at least one option to vote");
                          }
                          // Check if at least one vote has been entered
                          else if (controller.votesCastControllers == null ||
                              controller.votesCastControllers.isEmpty ||
                              controller.votesCastControllers.every(
                                  (controller) => controller.text.isEmpty)) {
                            showSnackBar(context,
                                "Please enter at least one number of votes");
                          }
                          // Check if logArray is null or empty
                          else if (controller.logArray == null ||
                              controller.logArray.isEmpty) {
                            showSnackBar(context, "Please enter log details");
                          } else {
                            // Call the submit function if at least one option and one vote are valid
                            evotingBottomSheetSubmit(context);
                          }
                        }
                      : () async {},
                  buttonText: "Submit",
                ),
              ),
              TextButton(
                onPressed: isVoteAllowed
                    ? () {
                        controller.resetAll();
                        setState(() {});
                      }
                    : null,
                child: Text(
                  'Reset All',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isVoteAllowed
                          ? const Color(0xFF1E32FA)
                          : NsdlInvestor360Colors.lightGrey12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void submitVote() {
    List<String> resolutionIds = [];
    List<String> optionIDs = [];
    List<int> votesCastList = [];

    for (int index = 0;
        index < controller.evotingResolutionListData.length;
        index++) {
      var resolutionData = controller.evotingResolutionListData[index];

      if (controller.selectedValues[index] != null) {
        resolutionIds.add(resolutionData.resolutionId.toString());
        optionIDs.add(controller.selectedValues[index] == 0 ? "1" : "2");
        votesCastList
            .add(int.parse(controller.votesCastControllers[index].text));
      }
    }

    controller.castVoteAPI(
      controller.votingCycles[index].evenId.toString(),
      resolutionIds,
      optionIDs,
      votesCastList,
    );
  }

  void calculateAllowedVotes() {
    String isin = index < controller.votingCycles.length
        ? controller.votingCycles[index].isin.toString()
        : '';

    var matchingHolding = displayHoldingDataList.firstWhere(
      (holding) => holding.isin == isin,
      orElse: () => HoldingDataList(isin: '', totalPosition: 0),
    );

    double maxVoteAllowed = index < controller.votingCycles.length
        ? double.parse(controller.votingCycles[index].votesAllowed.toString())
        : 0;

    isVoteAllowed = false;

    for (int i = 0; i < controller.evotingResolutionListData.length; i++) {
      int votesCast = int.tryParse(
              controller.evotingResolutionListData[i].votesCast?.toString() ??
                  '0') ??
          0;
      int allowedVotes =
          (maxVoteAllowed * matchingHolding.totalPosition).toInt() - votesCast;

      print("Index: $i, Allowed Votes: $allowedVotes");
      if (allowedVotes > 0) {
        isVoteAllowed = true;
        return;
      }
    }
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    controller.votesCastControllers
        .forEach((controller) => controller.dispose());
    super.dispose();
  }

  void evotingBottomSheetSubmit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SizedBox(
            height: 225,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Confirmation",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Do You Want To Confirm",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        submitVote();
                        Get.back();

                        //   controller.castVoteAPI();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            NsdlInvestor360Colors.bottomCardHomeColour2,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(
                              color: Color(0xFF2958FF),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MaxVoteInputFormatter extends TextInputFormatter {
  final int maxVotes;

  MaxVoteInputFormatter(this.maxVotes);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value can be parsed as an integer
    final int? enteredValue = int.tryParse(newValue.text);

    // If entered value is null or greater than maxVotes, revert to old value
    if (enteredValue == null || enteredValue > maxVotes) {
      return oldValue;
    }

    return newValue;
  }
}
