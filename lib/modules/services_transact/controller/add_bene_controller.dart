import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/services_transact/controller/beneficiary_details_controller.dart';
import 'package:investor360/modules/services_transact/data/service_transact_repo.dart';
import 'package:investor360/modules/services_transact/model/addNsdlBeneficiaryRequest.dart';
import 'package:investor360/modules/services_transact/model/addNsdlBeneficiaryResponse.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/error_message.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes.dart';
import '../../../shared/loading/popup_loading.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../login/model/common_request.dart';
import '../../login/model/validateOtp_request.dart';
import '../model/addNonNsdlBeneRequest.dart';
import '../views/bottomsheet_add_bene.dart';

class AddBeneController extends GetxController {
  RxString beneficiaryName = "".obs;
  final BeneficiaryDetailsController controller =
      Get.put(BeneficiaryDetailsController());
  final BottomSheetViewBeneController bottomController =
      Get.put(BottomSheetViewBeneController());

  final ServiceTransactRepo serviceTransactRepo = ServiceTransactRepo();
  TextEditingController dpIdController = TextEditingController();
  TextEditingController reEnterDpIdController = TextEditingController();
  TextEditingController dematController = TextEditingController();
  TextEditingController reEnterdematController = TextEditingController();
  TextEditingController clientIdController = TextEditingController();
  TextEditingController reEnterClientIdController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController textEditingControllerBeneidAddBene =
      TextEditingController();
  var isLoading = false.obs;
  RxBool visibleBeneNameCard = RxBool(false);
  RxString selectedDpIdValue = RxString("");
  RxString selectedAccountType = RxString("");
  var showClientIdFields = true.obs; // By default, show client ID fields
  var showValidateButton = true.obs; // By default, show validate button

  var dpId_clientId = ''.obs;
  final DashboardController dashboardController =
      Get.put(DashboardController());
  var selectedClientId = "".obs;
  var selectedDpId = "".obs;

  @override
  void onInit() {
    controller.isSpecificPageActive = false;
    // print(
    //     "The BottomSheet Value is : ${controller.textEditingControllerBeneidViewBene.value.text}");
    initializeData();
    super.onInit();
  }

  void initializeData() async {
    await setInitialDpIdAndClientId();
  }

  Future<void> setInitialDpIdAndClientId() async {
    if (dashboardController.responseData.value != null) {
      var dematAccountList =
          dashboardController.responseData.value!.dematAccountList;
      if (dematAccountList != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectedDpId.value = dematAccountList[0].dpId ?? "";
          selectedClientId.value =
              dematAccountList[0].clientId.toString() ?? "";
          textEditingControllerBeneidAddBene.text =
              "${selectedDpId.value}-${selectedClientId.value}";
          bottomController.setSelectedIndex(0);
        });
      }
    }
  }

  bool validateDPID(String dpid) {
    final dpidRegExp = RegExp(r"^IN\d{6}$");
    if (dpid == null || dpid.isEmpty) {
      return false; // Handle empty DP ID
    }
    return dpidRegExp.hasMatch(dpid.toUpperCase()); // Ensure case-insensitivity
  }

  bool validatePan(BuildContext context) {
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

    if (!validate(context)) {
      return false;
    } else if (panController.text.isEmpty) {
      showErrorDialog("Please Enter PAN Number", context);
      return false;
    } else if (panController.text.length != 10) {
      showErrorDialog("Please Enter valid PAN Number", context);
      return false;
    } else if (!panRegex.hasMatch(panController.text)) {
      showErrorDialog('Invalid PAN format', context);
      return false;
    } else {
      return true;
    }
  }

  bool validate(BuildContext context) {
    if (selectedDpIdValue == null ||
        selectedDpIdValue.isEmpty ||
        selectedDpIdValue == "") {
      showErrorDialog("Please Select a DPID ", context);
      return false;
    } else if (selectedAccountType == null ||
        selectedAccountType.isEmpty ||
        selectedAccountType == "") {
      showErrorDialog("Please Select AccountType ", context);
      return false;
    } else if (!validateDPID(dpIdController.text)) {
      showErrorDialog("Invalid DP ID", context);
      return false;
    } else if (dpIdController.text != reEnterDpIdController.text) {
      showErrorDialog("DP ID doesn't Match", context);
      return false;
    } else if (clientIdController.text == "" ||
        clientIdController.text.length != 8) {
      showErrorDialog("Invalid Client ID", context);
      return false;
    } else if (clientIdController.text != reEnterClientIdController.text) {
      showErrorDialog("Client ID doesn't Match", context);
      return false;
    } else {
      return true;
    }
  }

  void resetTextFields() {
    dpIdController.clear();
    reEnterDpIdController.clear();
    dematController.clear();
    reEnterdematController.clear();
    clientIdController.clear();
    reEnterClientIdController.clear();
    panController.clear();
    showClientIdFields = true.obs;
    showValidateButton = true.obs;
    visibleBeneNameCard.value = false;
  }

  void filterHoldingsByDPIDAndClientID(var dpId, var clientId) {
    if (dashboardController.responseData.value != null &&
        dashboardController.responseData.value!.holdingDataList != null) {
      if (dpId == "ALL") {
        selectedClientId.value = "ALL";
      } else if (dpId == null || clientId == null) {
        selectedClientId.value = "";
      } else {}
    }
  }

  Future<AddBeneficiaryResponse?> addNsdlBeneficiaryAPi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      print("Session ID is missing in SharedPreferences");
      isLoading.value = false;
      return null;
    }

    NsdlBeneficiary nsdlBeneficiary = NsdlBeneficiary(
      srcDpId: controller.selectedDpId.value.toString(),
      srcClientId: controller.selectedClientId.value.toString(),
      dpId: dpIdController.text,
      clientId: clientIdController.text,
      pan: panController.text,
    );

    /*   NsdlBeneficiary nsdlBeneficiary = NsdlBeneficiary(
      srcDpId: selectedDpId.value = "IN302871",
      srcClientId: selectedClientId.value = "42997279",
      dpId: dpIdController.text = "IN302871",
      clientId: clientIdController.text = "44969662",
      pan: panController.text = "CTSPD4406L",
    );*/
    SessionData sessionData = SessionData(
      sessionId: sessionId,
    );

    AddNsdlBeneficiaryRequest addNSdlBeneficiariesRequest =
        AddNsdlBeneficiaryRequest(
      nsdlBeneficiary: nsdlBeneficiary,
      sessionData: sessionData,
    );

    try {
      var res = await serviceTransactRepo
          .addNsdlBeneficiary(addNSdlBeneficiariesRequest);

      print('Response data: ${res.toString()}');

      if (res != null) {
        // Decode the response if it's a string
        var decodedResponse = json.decode(res.toString());
        if (decodedResponse is Map<String, dynamic>) {
          String name = decodedResponse['name'];
          print('Name: $name');
          beneficiaryName.value = name;
          visibleBeneNameCard.value = true;
        } else {
          print('Invalid response format');
        }
      } else {
        print('Response is null');
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmNsdlBeneficiaryApi() async {
    CommonRequest commonRequest = CommonRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    commonRequest.sessionId = sessionId;

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await serviceTransactRepo.confirmNsdlBeneficiary(commonRequest);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        final jsonResponse = res.data;
        final sessionId = jsonResponse['sessionId'];
        if (sessionId != null) {
          Get.bottomSheet(
            AddBeneBottomSheetVerify(
              called: "Add",
            ),
          );

          print("session id: $sessionId");
        } else {
          print(res);
          PopUpLoading.onLoadingOff(Get.context!);
        }
      } else {
        print('Failed to fetch data: $res');
        PopUpLoading.onLoadingOff(Get.context!);
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> validateOTPAddBeneficiaryApi(
      TextEditingController pin, BuildContext context, String called) async {
    ValidateOtpRequest validateotp = ValidateOtpRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    validateotp.sessionId = sessionId;
    validateotp.otp = pin.text;

    try {
      var res;
      if (called == "Delete") {
        res = await serviceTransactRepo.validateOTPAddBeneficiary(
            validateotp, "Delete");
        print(res);
      } else if (called == "Add") {
        res = await serviceTransactRepo.validateOTPAddBeneficiary(
            validateotp, "Add");
        print(res);
      }
      if (res != null /*&& res.statusCode == 200*/) {
        final jsonResponse = res.data;
        final sessionId = jsonResponse['sessionId'];
        prefs.setString(KeyConstants.sessionId, sessionId);
        // final otpValidated = jsonResponse['otpValidated'];
        final message = jsonResponse['message'] ?? 'No Message provided';
        if (sessionId != null) {
          print(res.data);

          if (called == "Add") {
            resetTextFields();
            Get.toNamed(Routes.beneficiary.name);
            showSnackBarCustom(
                "Success",
                "Your request to Add Beneficiary is submitted Successfully",
                NsdlInvestor360Colors.green,
                Icons.check_circle);
          } else if (called == "Delete") {
            resetTextFields();
            Get.back();
            Get.toNamed(Routes.beneficiary.name);
            showSnackBarCustom(
                "Delete",
                "Your request to Delete Beneficiary is submitted.",
                NsdlInvestor360Colors.redFailed,
                Icons.delete_forever);
          }
        } else {
          print('$message');
          // hasError.value = true;
          //howSnackBar(context, message);
        }
      } else {
        pin.clear();
        print('Failed to fetch data: ');
        //  hasError.value = true;
        //   showSnackBar(context, 'Entered OTP is incorrect');
      }
    } catch (e) {
      print("#Exception" + e.toString());
      if (e.toString().contains("Unauthorized")) {
        pin.clear();
        print('error ');
        //  hasError.value = true;
        //  showSnackBar(context, 'Entered OTP is incorrect');
      } else {
        pin.clear();
        print('Failed to fetch data: ');
        //  hasError.value = true;
        //showSnackBar(context, 'No Demat Accounts exist with the provided details!');
      }
    } finally {
      // Get.back();
    }
  }

  Future<void> addNonNsdlBeneficiaryAPi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      print("Session ID is missing in SharedPreferences");
      isLoading.value = false;
      return null;
    }

    NonNSDLBeneficiary nonNSDLBeneficiary = NonNSDLBeneficiary(
      srcDpId: selectedDpId.value = selectedDpId.value.toString(),
      srcClientId: selectedClientId.value = selectedClientId.value.toString(),
      dematAccount: dematController.text,
      pan: panController.text,
      //     dematAccount: dematController.text = "1234567887654321",
      //    pan: panController.text = "SANDP3456Y",
    );

    SessionDataNonNsdl sessionDataNonNsdl =
        SessionDataNonNsdl(sessionId: sessionId);

    GetNonNSDLBeneficiaryRequest getNonNSDLBeneficiaryRequest =
        GetNonNSDLBeneficiaryRequest(
      nonNSDLBeneficiary: nonNSDLBeneficiary,
      sessionData: sessionDataNonNsdl,
    );

    try {
      var res = await serviceTransactRepo
          .addNonNsdlBeneficiary(getNonNSDLBeneficiaryRequest);

      print('Response data: ${res.toString()}');

      if (res != null /*&& res.statusCode == 200*/) {
        final jsonResponse = res.data;
        final sessionId = jsonResponse['sessionId'];
        prefs.setString(KeyConstants.sessionId, sessionId);
        // final otpValidated = jsonResponse['otpValidated'];
        final message = jsonResponse['message'] ?? 'No Message provided';
        if (sessionId != null) {
          print(res.data);

          Get.bottomSheet(
            AddBeneBottomSheetVerify(
              called: "Add",
            ),
          );
        } else {
          print('$message');
        }
      } else {
        print('Failed to fetch data: ');
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelNSDLBeneficiaryApi() async {
    CommonRequest commonRequest = CommonRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);
    commonRequest.sessionId = sessionId;

    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await serviceTransactRepo.cancelNSDLBeneficiary(commonRequest);

      if (res != null && res.statusCode == 200) {
        PopUpLoading.onLoadingOff(Get.context!);
        final jsonResponse = res.data;
        final sessionId = jsonResponse['sessionId'];
        if (sessionId != null) {
          Get.toNamed(Routes.beneficiary.name);

          print("session id: $sessionId");
        } else {
          print(res);
          PopUpLoading.onLoadingOff(Get.context!);
        }
      } else {
        print('Failed to fetch data: $res');
        PopUpLoading.onLoadingOff(Get.context!);
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      throw Exception('Failed to load data: $e');
    }
  }
}
