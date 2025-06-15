import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/services_transact/controller/add_bene_controller.dart';
import 'package:investor360/modules/services_transact/controller/beneficiary_details_controller.dart';
import 'package:investor360/modules/services_transact/views/bottomsheet_add_bene.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';

class BeneficiaryDetails extends StatefulWidget {
  BeneficiaryDetails({super.key});

  @override
  State<BeneficiaryDetails> createState() => _BeneficiaryDetailsState();
}

class _BeneficiaryDetailsState extends State<BeneficiaryDetails> {
  // final AddBeneController addBeneController = Get.put(AddBeneController());
  final BeneficiaryDetailsController controller =
      Get.put(BeneficiaryDetailsController());
  final BottomSheetViewBeneController bottomController =
      Get.put(BottomSheetViewBeneController());
  Color dividerColor = const Color(0xFFB2B2B2);

  @override
  void initState() {
    controller.isSpecificPageActive = true;
    // controller.getBeneficiaryApi(controller.selectedDpId.value.toString(),
    //     controller.selectedClientId.value.toString());
    controller.initializeData();
    bottomController.resetSelection();
    // controller.setInitialDpIdAndClientId();
    // bottomController.setSelectedIndex(0);
    super.initState();
  }

  @override
  void dispose() {
    controller.isSpecificPageActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NsdlInvestor360Colors.pureWhite,
        elevation: 0.5,
        shadowColor: Colors.white.withOpacity(0.6),
        title: Text(
          "Beneficiary Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.toNamed(Routes.services.name);
          },
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: NsdlInvestor360Colors.backLightBlue),
        child: Column(
          children: [
            Container(
              color: NsdlInvestor360Colors.backLightBlue,
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        ViewBeneBottomSheet(),
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
                            controller.textEditingControllerBeneidViewBene
                                .text = value["dpId_clientId"] ?? "";
                            print('Selected: $value');
                          });
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
                            controller:
                                controller.textEditingControllerBeneidViewBene,
                            decoration: InputDecoration(
                              labelText: "Demat Account",
                              labelStyle: const TextStyle(
                                color: Colors.black,
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
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ACCOUNTS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.beneficiaries.isEmpty) {
                  return const Center(child: Text('No beneficiaries found.'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Adding padding to the ListView
                    itemCount: controller.beneficiaries.length,
                    itemBuilder: (context, index) {
                      var beneficiary = controller.beneficiaries[index];
                      String type = beneficiary.dpId.startsWith('IN')
                          ? 'NSDL'
                          : 'NON-NSDL';
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20), // Adding spacing between items
                        child: Beneficiary(
                          type: type,
                          subtext:
                              '${type} | ${beneficiary.dpId}-${beneficiary.clientId}',
                          status: beneficiary.status,
                          dpId: beneficiary.dpId,
                          clientId: beneficiary.clientId,
                          pan: beneficiary.pan,
                          name: beneficiary.name ?? "NA",
                        ),
                      );
                    },
                  );
                }
              }),
            ),

            const SizedBox(height: 20),
            // const Divider(height: 1, color: Colors.grey),
            DottedLine(
              dashColor: dividerColor,
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 60),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.addBeneficiary.name);
                  // addBeneController.resetTextFields();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Add another Beneficiary",
                  style: TextStyle(
                    fontSize: 16.5,
                    fontFamily: GoogleFonts.lato().fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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

class Beneficiary extends StatelessWidget {
  final BeneficiaryDetailsController controller =
      Get.put(BeneficiaryDetailsController());
  var dpIdClientId;

  Beneficiary({
    super.key,
    required this.name,
    required this.subtext,
    required this.status,
    required this.type,
    required this.dpId,
    required this.clientId,
    required this.pan,
  });
  final String name;
  final String subtext;
  final String status;
  final String type;
  final String dpId;
  final String clientId;
  final String pan;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        controller.isDeleteVisible = false;
        break;
      case 'Delete Pending':
        statusColor = Colors.grey;
        controller.isDeleteVisible = false;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      case 'Active':
        statusColor = Colors.green;
        controller.isDeleteVisible = true;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text(subtext),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (type == "NSDL") {
                      dpIdClientId = "$dpId-$clientId";
                    } else {
                      dpIdClientId = "$dpId$clientId";
                    }

                    Get.bottomSheet(
                      AddBeneBottomSheetDelete(
                          dpId_clientId: dpIdClientId,
                          dpId: dpId,
                          clientId: clientId,
                          pan: pan,
                          type: type),
                    );

                    print(
                        "DpId and ClientID of the selected beneficiary: $dpId-$clientId \n "
                        "Pan of the selected beneficiary: $pan");
                  },
                  child: Visibility(
                      visible: controller.isDeleteVisible,
                      child: SvgPicture.asset('assets/delete.svg')),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
