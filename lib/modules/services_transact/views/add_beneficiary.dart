import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/modules/services_transact/controller/add_bene_controller.dart';
import 'package:investor360/modules/services_transact/controller/beneficiary_details_controller.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/text_formatter.dart';

class AddBeneficiary extends StatefulWidget {
  const AddBeneficiary({super.key});

  @override
  State<AddBeneficiary> createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
  final AddBeneController controller = Get.put(AddBeneController());

  final BeneficiaryDetailsController Benecontroller =
      Get.put(BeneficiaryDetailsController());
  final BottomSheetViewBeneController bottomController =
      Get.put(BottomSheetViewBeneController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Benecontroller.isSpecificPageActive = false;
    bottomController.resetSelection();
    Benecontroller.setInitialDpIdAndClientId();
    controller.initializeData();
    // bottomController.setSelectedIndex(0);
    super.initState();
  }

  void resetTextFields() {
    controller.showClientIdFields.value = true;
    controller.showValidateButton.value = true;
    controller.dpIdController.clear();
    controller.reEnterDpIdController.clear();
    controller.clientIdController.clear();
    controller.reEnterClientIdController.clear();
    controller.dematController.clear();
    controller.reEnterdematController.clear();
    controller.panController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (controller.visibleBeneNameCard.value == true) {
            return false;
          } else {
            Benecontroller.isSpecificPageActive = true;
            Get.toNamed(Routes.beneficiary.name);
            resetTextFields();
            // Benecontroller.getBeneficiaryApi(
            //     Benecontroller.selectedClientId.value.toString(),
            //     Benecontroller.selectedClientId.value.toString());
            return Future.value(false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: NsdlInvestor360Colors.pureWhite,
            elevation: 0.5,
            shadowColor: Colors.white.withOpacity(0.6),
            title: Text(
              "Add Beneficiary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
            leading: Visibility(
              visible: controller.visibleBeneNameCard.value ? false : true,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Benecontroller.isSpecificPageActive = true;
                  resetTextFields();
                  // Benecontroller.getBeneficiaryApi(
                  //     Benecontroller.selectedClientId.value.toString(),
                  //     Benecontroller.selectedClientId.value.toString());
                  // Navigator.of(context).pop();
                  Get.toNamed(Routes.beneficiary.name);
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                        color: NsdlInvestor360Colors.backLightBlue),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Stack(
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
                                      //   setState(() {
                                      controller.dpId_clientId.value =
                                          value["dpId_clientId"];
                                      controller
                                          .textEditingControllerBeneidAddBene
                                          .text = value["dpId_clientId"] ?? "";
                                      if (kDebugMode) {
                                        print('Selected: $value');
                                      }
                                      // });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, top: 2),
                                  child: SizedBox(
                                    height: 50,
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextField(
                                        controller: controller
                                            .textEditingControllerBeneidAddBene,
                                        decoration: InputDecoration(
                                          labelText: "Demat Account",
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
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
                                          disabledBorder: OutlineInputBorder(
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
                                            fontFamily:
                                                GoogleFonts.roboto().fontFamily,
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
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              labelText: 'Account Type',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: 'Select Account Type',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an Account Type';
                              }
                              return null;
                            },
                            items: <String>['NSDL', 'Non-NSDL']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _formKey.currentState?.validate();

                              controller.selectedAccountType.value = value!;
                              if (value == 'Non-NSDL') {
                                controller.showClientIdFields.value = false;
                                controller.showValidateButton.value = false;
                                controller.visibleBeneNameCard.value = false;
                                controller.dematController.clear();
                                controller.reEnterdematController.clear();
                                controller.panController.clear();
                              } else {
                                controller.showClientIdFields.value = true;
                                controller.showValidateButton.value = true;
                                controller.dpIdController.clear();
                                controller.reEnterDpIdController.clear();
                                controller.clientIdController.clear();
                                controller.reEnterClientIdController.clear();
                                controller.panController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Obx(() {
                          return Visibility(
                            visible: controller.showClientIdFields.value,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8),
                                UpperCaseTextFormatter()
                              ],
                              controller: controller.dpIdController,
                              decoration: const InputDecoration(
                                labelText: 'DP ID',
                                hintText: 'Enter DP ID',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter DP ID';
                                } else if (!controller.validateDPID(value)) {
                                  return 'Invalid DP ID';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formKey.currentState?.validate();
                              },
                            ),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: controller.showClientIdFields.value,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                  UpperCaseTextFormatter()
                                ],
                                controller: controller.reEnterDpIdController,
                                decoration: const InputDecoration(
                                  labelText: 'Re-Enter DP ID',
                                  hintText: 'Re-Enter DP ID',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please re-enter DP ID';
                                  } else if (value !=
                                      controller.dpIdController.text) {
                                    return 'DP ID do not match';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _formKey.currentState?.validate();
                                },
                              ),
                            ),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: !controller.showClientIdFields.value,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              // textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16),
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: controller.dematController,
                              decoration: const InputDecoration(
                                labelText: 'Demat Account Number',
                                hintText: 'Enter Demat Account Number',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Demat Account Number';
                                } else if (value.length != 16) {
                                  return 'Invalid Demat Account Number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formKey.currentState?.validate();
                              },
                            ),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: !controller.showClientIdFields.value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(16),
                                  UpperCaseTextFormatter(),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: controller.reEnterdematController,
                                decoration: const InputDecoration(
                                  labelText: 'Re-Enter Demat Account Number',
                                  hintText: 'Re-Enter Demat Account Number',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please re-enter Demat Account Number';
                                  } else if (value !=
                                      controller.dematController.text) {
                                    return 'DP ID do not match';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _formKey.currentState?.validate();
                                },
                              ),
                            ),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: controller.showClientIdFields.value,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8),
                                    ],
                                    controller: controller.clientIdController,
                                    decoration: const InputDecoration(
                                      labelText: 'Client ID',
                                      hintText: 'Enter Client ID',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 12),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Client ID';
                                      } else if (value.length != 8) {
                                        return 'Client ID must be 8 digits';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _formKey.currentState?.validate();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(8),
                                  ],
                                  controller:
                                      controller.reEnterClientIdController,
                                  decoration: const InputDecoration(
                                    labelText: 'Re-Enter Client ID',
                                    hintText: 'Re-Enter Client ID',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please re-enter the Client ID';
                                    } else if (value !=
                                        controller.clientIdController.text) {
                                      return 'Client IDs do not match';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _formKey.currentState?.validate();
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        }),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Z0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          controller: controller.panController,
                          decoration: const InputDecoration(
                            labelText: 'PAN',
                            hintText: 'Enter PAN Number',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a PAN Number';
                            } else if (value.length != 10) {
                              return 'PAN must be 10 characters';
                            } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                                .hasMatch(value)) {
                              return 'Invalid PAN format';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                            if (value.length == 10) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Obx(() {
                          return Visibility(
                            visible: controller.showValidateButton.value ==
                                    true &&
                                controller.visibleBeneNameCard.value == false,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    bool beneficiaryExists = Benecontroller
                                        .beneficiaries
                                        .any((beneficiary) =>
                                            beneficiary.dpId ==
                                                controller
                                                    .dpIdController.text &&
                                            beneficiary.clientId ==
                                                controller
                                                    .clientIdController.text);

                                    if (beneficiaryExists) {
                                      showSnackBar(context,
                                          "This Beneficiary already added");
                                    } else {
                                      controller.addNsdlBeneficiaryAPi();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NsdlInvestor360Colors
                                      .bottomCardHomeColour2,
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
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible:
                                controller.visibleBeneNameCard.value == true,
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'BENEFICIARY',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    title: Obx(() {
                                      return Text(
                                        controller.beneficiaryName.value
                                                .isNotEmpty
                                            ? controller.beneficiaryName.value
                                            : "No beneficiary name available",
                                      );
                                    }),
                                    // subtitle: Text('NSDL  |  2589 236 2689'),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Visibility(
                                  visible: controller.visibleBeneNameCard.value,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              controller.visibleBeneNameCard
                                                  .value = false;
                                              controller.resetTextFields();
                                              controller
                                                  .cancelNSDLBeneficiaryApi();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor:
                                                  NsdlInvestor360Colors
                                                      .lightestgrey,
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize: 16.5,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                color: NsdlInvestor360Colors
                                                    .bottomCardHomeColour2,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Adding some space between the buttons
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                controller
                                                    .confirmNsdlBeneficiaryApi();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor:
                                                  NsdlInvestor360Colors
                                                      .bottomCardHomeColour2,
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                            ),
                                            child: Text(
                                              "Submit NSDL",
                                              style: TextStyle(
                                                fontSize: 16.5,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        //NON NSDL
                        Obx(() {
                          return Visibility(
                            visible: !controller.showClientIdFields.value &&
                                controller.visibleBeneNameCard.value == false,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // controller.visible.value = false;
                                  if (_formKey.currentState!.validate()) {
                                    // controller.visible.value = true;
                                    controller.addNonNsdlBeneficiaryAPi();

                                    /* if (controller.dematController.value.text.length == 16) {
                                      String firstHalf = controller.dematController.value.text.substring(0, 8);
                                      String secondHalf = controller.dematController.value.text.substring(8, 16);

                                      print("First half: $firstHalf");
                                      print("Second half: $secondHalf");


                                      bool beneficiaryExists = Benecontroller.beneficiaries.any((beneficiary) =>
                                      beneficiary.dpId == firstHalf &&
                                          beneficiary.clientId == secondHalf);

                                      if (beneficiaryExists) {
                                        showSnackBar(context,
                                            "This Beneficiary already added");
                                      } else {
                                        controller.addNonNsdlBeneficiaryAPi();
                                      }


                                    } else {
                                      controller.addNonNsdlBeneficiaryAPi();
                                      print("The value is not 16 digits long.");
                                    }*/
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NsdlInvestor360Colors
                                      .bottomCardHomeColour2,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: Text(
                                  "Submit Non-NSDL",
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
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
