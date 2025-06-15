import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/dashboard/data/dashboard_repo.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataRequest.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/utils/base_request.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/formatnumber.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/base_response.dart';
import '../model/GetNsdlHoldingDataResponse.dart';

class DashboardController extends GetxController {
  bool isBottomSheetShown = false;

  var isLoading = false.obs;
  final DashboardRepo dashboardRepo = DashboardRepo();
  Rx<GetNsdlHoldingDataResponse?> responseData =
      Rx<GetNsdlHoldingDataResponse?>(null);

  var displayDematAccountList = <DematAccountList>[].obs;
  var displayHoldingDataList = <HoldingDataList>[].obs;
  var shareee = <HoldingDataList>[].obs;

  Map<String, BusinessSectorValue> businessSectorTotalValues = {};

  //var displayCompanyNameList = <HoldingDataList>[].obs;

  RxDouble totalValue = 0.00.obs;
  TextEditingController textEditingControllerBeneid = TextEditingController();

  RxString selectedMarketValue = ''.obs;
  var dpId_clientId = ''.obs;

  //Map<String, double> businessSectorText = "".obs;
  RxDouble mFValue = 0.0.obs;
  RxDouble equityValue = 0.0.obs;
  RxDouble deptValue = 0.0.obs;
  RxDouble othersValue = 0.0.obs;

  Map<String, double> dataMap = {};

  Map<String, double> securityTypeTotalValues = {
    'MUTUAL_FUNDS': 0.0,
    'EQUITY': 0.0,
    'DEBT': 0.0,
    'OTH': 0.0,
  };

  List<Color> colorListSectorComp = [];

  var selectedBeneficiary = 'All'.obs;
  var items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'].obs;

  var isDashboardDataLoaded = false.obs;

  @override
  void onInit() async {
    await initializeData();

    super.onInit();
  }

  Future<void> initializeData() async {
    if (!isDashboardDataLoaded.value) {
      await fetchNsdlHoldingDataApi();
      isDashboardDataLoaded.value = true;
    }
  }

  void filterHoldingsByDPIDAndClientID(var dpId, var clientId) {
    if (responseData.value != null &&
        responseData.value!.holdingDataList != null) {
      if (dpId == "ALL") {
        displayHoldingDataList.value =
            responseData.value!.holdingDataList!.where((holding) {
          return holding.clientId == clientId;
        }).toList();
        displayHoldingDataList.value = responseData.value!.holdingDataList!;
      } else {
        displayHoldingDataList.value =
            responseData.value!.holdingDataList!.where((holding) {
          return holding.dpId == dpId && holding.clientId == clientId;
        }).toList();
      }
    } else {
      displayHoldingDataList.value = [];
    }

    calculateTotalValue(displayHoldingDataList);
    calculateSecurityTotalValue(displayHoldingDataList);
    calculateBusinessSectorTotalValue(displayHoldingDataList);

    /*for (var holdingData in displayHoldingDataList) {
      print("value here comes ${holdingData.totalValue}");
    }
*/

    initializeDataMap();
  }

  Future<void> fetchNsdlHoldingDataApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    GetNsdlHoldingDataRequest getNsdlHoldingDataRequest =
        GetNsdlHoldingDataRequest(
      sessionId: sessionId,
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      signCS: getSignChecksum(
          "Device" +
              sessionId +
              (await getDeviceId()).toString() +
              getDeviceOS(),
          ""),
    );

    try {
      //   PopUpLoading.onLoading(Get.context!);
      isLoading.value = true;
      var res =
          await dashboardRepo.getNsdlHoldingDataApi(getNsdlHoldingDataRequest);

      if (res != null && res.statusCode == 200) {
        // Ensure res.data is a Map
        Map<String, dynamic> mainJson;
        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else {
          mainJson = res.data;
        }

        if (mainJson['responseCode'] == "1" ||
            mainJson['responseCode'] == "-1") {
          // PopUpLoading.onLoadingOff(Get.context!);
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        // Check if 'data' field exists and is not null
        if (mainJson['data'] == null) {
          throw Exception('Data field is null');
        }

        // Extract and decode the nested JSON string in the 'data' field
        Map<String, dynamic> nestedJson;
        try {
          nestedJson = jsonDecode(mainJson['data']);
        } catch (e) {
          throw Exception('Failed to decode nested JSON: $e');
        }

        // Replace the 'data' field in the main JSON with the nested JSON
        mainJson['data'] = nestedJson;

        // Parse the BaseResponse
        BaseResponse<GetNsdlHoldingDataResponse> response =
            BaseResponse.fromJson(
          mainJson,
          (dataJson) => GetNsdlHoldingDataResponse.fromJson(dataJson),
        );

        if (response.responseCode == "0") {
          print("Response data: " + response.data.toString());

          responseData.value = response.data;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(KeyConstants.name, responseData.value!.name);

          displayDematAccountList.value = response.data?.dematAccountList ?? [];
          shareee.value = response.data?.holdingDataList ?? [];
          calculateTotalValue(responseData.value?.holdingDataList);
          calculateSecurityTotalValue(responseData.value?.holdingDataList);
          calculateBusinessSectorTotalValue(
              responseData.value?.holdingDataList);
          initializeDataMap();

          print(responseData.value);
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      } else {
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

/*  Future<void> fetchNsdlHoldingDataApi() async {
    GetNsdlHoldingDataRequest getNsdlHoldingDataRequest = GetNsdlHoldingDataRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    getNsdlHoldingDataRequest.channelId = "Web";
    getNsdlHoldingDataRequest.deviceId = await getDeviceId();
    getNsdlHoldingDataRequest.deviceOS = getDeviceOS();
    getNsdlHoldingDataRequest.sessionId = sessionId;
    getNsdlHoldingDataRequest.signCS = getSignChecksum(getNsdlHoldingDataRequest.toString(), "");


    try {
      PopUpLoading.onLoading(Get.context!);
      var res = await dashboardRepo.getNsdlHoldingDataApi(getNsdlHoldingDataRequest);


      if (res != null && res.statusCode == 200) {

         BaseResponse<GetNsdlHoldingDataResponse> response = BaseResponse.fromJson(res.data,
          (dataJson) => GetNsdlHoldingDataResponse.fromJson(dataJson),);

        if (response.responseCode == "0") {



          responseData.value = response.data;// jsonDecode(response.data.toString());

          print(responseData.value);

          displayDematAccountList.value = response.data?.dematAccountList ?? [];

          calculateTotalValue(responseData.value?.holdingDataList);
          calculateSecurityTotalValue(responseData.value?.holdingDataList);
          calculateBusinessSectorTotalValue(responseData.value?.holdingDataList);
          initializeDataMap();

          print(responseData.value);
          PopUpLoading.onLoadingOff(Get.context!);
        } else if (response.responseCode == "1" || response.responseCode == "-1") {
          PopUpLoading.onLoadingOff(Get.context!);
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }










    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception " + e.toString());
      throw Exception('Failed to load data: $e');
    }
  }*/

  /*      // Check if the response is a string (error message)
      if (res is String) {
        // Handle error response
        print('Failed to fetch data: $res');
        PopUpLoading.onLoadingOff(Get.context!);
        throw Exception('Failed to load data: $res');
      } else {
        final jsonResponse = res.data;

        if (jsonResponse == null) {
          PopUpLoading.onLoadingOff(Get.context!);
          throw Exception('Failed to load data: response data is null');
        }

        responseData.value = GetNsdlHoldingDataResponse.fromJson(jsonResponse);

        displayDematAccountList.value = responseData.value?.dematAccountList ?? [];

        calculateTotalValue(responseData.value?.holdingDataList);
        calculateSecurityTotalValue(responseData.value?.holdingDataList);
        calculateBusinessSectorTotalValue(responseData.value?.holdingDataList);
        initializeDataMap();

       // print(responseData.value);
        PopUpLoading.onLoadingOff(Get.context!);
      }
*/

  void calculateTotalValue(List<HoldingDataList>? holdingDataList) {
    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      double total = 0.0;
      for (var holdingData in holdingDataList) {
        total += double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;
      }

      totalValue.value = total;
    }
  }

  void calculateSecurityTotalValue(List<HoldingDataList>? holdingDataList) {
    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      // Initialize temporary variables to hold the calculated values
      double mutualFundsTotal = 0.0;
      double equityTotal = 0.0;
      double debtTotal = 0.0;
      double othersTotal = 0.0;

      //  String companyName = "";

      for (var holdingData in holdingDataList) {
        final double totalValue =
            double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;

        switch (holdingData.securityType) {
          case 'MUTUAL_FUNDS':
            mutualFundsTotal += totalValue;
            break;
          case 'EQUITY':
            equityTotal += totalValue;
            //companyName = holdingData.companyName.toString();

            break;
          case 'DEBT':
            debtTotal += totalValue;
            break;
          default:
            othersTotal += totalValue;
            break;
        }
      }

      // Update the RxDouble variables with the calculated totals
      mFValue.value = mutualFundsTotal;
      equityValue.value = equityTotal;
      deptValue.value = debtTotal;
      othersValue.value = othersTotal;

      // Print the totals (optional)
      print("MUTUAL_FUNDS totalValue: $mutualFundsTotal");
      print("EQUITY totalValue: $equityTotal");
      print("DEBT totalValue: $debtTotal");
      print("OTH totalValue: $othersTotal");
      // print("Company Name: $companyName");
    }

    update();
  }

  List<Color> generateBaseColors(int numberOfSectors) {
    List<Color> colorList = [];
    for (int i = 0; i < numberOfSectors; i++) {
      Color color = generateColorForSector(i, numberOfSectors);
      colorList.add(color);
    }
    return colorList;
  }

  Color generateColorForSector(int sectorIndex, int numberOfSectors) {
    // Define the three primary colors
    Color primaryRed = Color.fromARGB(255, 234, 71, 114);
    Color primaryGreen = Color.fromARGB(255, 2, 104, 149);
    Color primaryBlue = Color.fromARGB(255, 61, 217, 87);

    // Handle edge case where numberOfSectors is 1
    if (numberOfSectors == 1) {
      return primaryRed;
    }

    // Calculate the interpolation factor
    double factor = sectorIndex / (numberOfSectors - 1);

    if (factor <= 1 / 3.0) {
      // Interpolate between red and green
      double localFactor = factor * 3;
      return Color.fromARGB(
        255,
        (primaryRed.red * (1 - localFactor) + primaryGreen.red * localFactor)
            .toInt(),
        (primaryRed.green * (1 - localFactor) +
                primaryGreen.green * localFactor)
            .toInt(),
        (primaryRed.blue * (1 - localFactor) + primaryGreen.blue * localFactor)
            .toInt(),
      );
    } else if (factor <= 2 / 3.0) {
      // Interpolate between green and blue
      double localFactor = (factor - 1 / 3.0) * 3;
      return Color.fromARGB(
        255,
        (primaryGreen.red * (1 - localFactor) + primaryBlue.red * localFactor)
            .toInt(),
        (primaryGreen.green * (1 - localFactor) +
                primaryBlue.green * localFactor)
            .toInt(),
        (primaryGreen.blue * (1 - localFactor) + primaryBlue.blue * localFactor)
            .toInt(),
      );
    } else {
      // Interpolate between blue and red
      double localFactor = (factor - 2 / 3.0) * 3;
      return Color.fromARGB(
        255,
        (primaryBlue.red * (1 - localFactor) + primaryRed.red * localFactor)
            .toInt(),
        (primaryBlue.green * (1 - localFactor) + primaryRed.green * localFactor)
            .toInt(),
        (primaryBlue.blue * (1 - localFactor) + primaryRed.blue * localFactor)
            .toInt(),
      );
    }
  }

/*  List<Color> generateBaseColors(int numberOfSectors) {
    List<Color> colorList = [];
    for (int i = 0; i < numberOfSectors; i++) {
      Color color = generateColorForSector(i, numberOfSectors);
      colorList.add(color);
    }
    return colorList;
  }

  Color generateColorForSector(int sectorIndex, int numberOfSectors) {
    // Define the three primary colors
    Color primaryRed = Color.fromARGB(255, 234, 71, 114);
    Color primaryGreen = Color.fromARGB(255, 2, 104, 149);
    Color primaryBlue = Color.fromARGB(255, 61, 217, 87);

    // Calculate the interpolation factor
    double factor = sectorIndex / (numberOfSectors - 1);

    if (factor <= 1 / 3) {
      // Interpolate between red and green
      double localFactor = factor * 3;
      return Color.fromARGB(
        255,
        (primaryRed.red * (1 - localFactor) + primaryGreen.red * localFactor)
            .toInt(),
        (primaryRed.green * (1 - localFactor) +
                primaryGreen.green * localFactor)
            .toInt(),
        (primaryRed.blue * (1 - localFactor) + primaryGreen.blue * localFactor)
            .toInt(),
      );
    } else if (factor <= 2 / 3) {
      // Interpolate between green and blue
      double localFactor = (factor - 1 / 3) * 3;
      return Color.fromARGB(
        255,
        (primaryGreen.red * (1 - localFactor) + primaryBlue.red * localFactor)
            .toInt(),
        (primaryGreen.green * (1 - localFactor) +
                primaryBlue.green * localFactor)
            .toInt(),
        (primaryGreen.blue * (1 - localFactor) + primaryBlue.blue * localFactor)
            .toInt(),
      );
    } else {
      // Interpolate between blue and red
      double localFactor = (factor - 2 / 3) * 3;
      return Color.fromARGB(
        255,
        (primaryBlue.red * (1 - localFactor) + primaryRed.red * localFactor)
            .toInt(),
        (primaryBlue.green * (1 - localFactor) + primaryRed.green * localFactor)
            .toInt(),
        (primaryBlue.blue * (1 - localFactor) + primaryRed.blue * localFactor)
            .toInt(),
      );
    }
  }*/

  List<Color> generateDarkerColors(List<Color> baseColors) {
    List<Color> colorList = [];
    for (Color color in baseColors) {
      // Generate darker shade for each color in the baseColors list
      Color darkerColor = generateDarkerColor(color);
      colorList.add(darkerColor);
    }
    return colorList;
  }

  Color generateDarkerColor(Color color) {
    // Extract RGB values from the base color
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    // Darken the color
    int darkenFactor = 30; // Adjust as needed for desired darkness
    red = (red - darkenFactor).clamp(0, 255);
    green = (green - darkenFactor).clamp(0, 255);
    blue = (blue - darkenFactor).clamp(0, 255);

    return Color.fromARGB(
      255, // Set alpha to 255 (fully opaque)
      red,
      green,
      blue,
    );
  }

  void initializeDataMap() {
    dataMap = {
      if (equityValue.value != 0)
        'Equity - ${formatNumber(double.parse(equityValue.value.toString()))}   ':
            equityValue.value,
      if (mFValue.value != 0)
        'Mutual Fund - ${formatNumber(double.parse(mFValue.value.toString()))} ':
            mFValue.value,
      if (deptValue.value != 0)
        'Debt - ${formatNumber(double.parse(deptValue.value.toString()))}     ':
            deptValue.value,
      if (othersValue.value != 0)
        'Others - ${formatNumber(double.parse(othersValue.value.toString()))}':
            othersValue.value,
    };

    // Ensure dataMap is not null or empty
    if (dataMap.isEmpty) {
      dataMap = {}; // Initialize with an empty map if needed
    }
  }
/*

  void initializeDataMap() {
    dataMap = {
      if (equityValue.value != 0)
        'Equity - ${formatNumber(double.parse(equityValue.value.toString()))}          ':
            equityValue.value,
      if (mFValue.value != 0)
        'MF - ${formatNumber(double.parse(mFValue.value.toString()))}        ':
            mFValue.value,
      if (deptValue.value != 0)
        'Debt - ${formatNumber(double.parse(deptValue.value.toString()))}                ':
            deptValue.value,
      if (othersValue.value != 0)
        'Others - ${formatNumber(double.parse(othersValue.value.toString()))} ':
            othersValue.value,
    };
  }
*/

  Future<void> logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    BaseRequest baseRequest = BaseRequest();
    baseRequest.channelId = "Device";
    baseRequest.deviceId = await getDeviceId();
    baseRequest.deviceOS = getDeviceOS();
    baseRequest.sessionId = sessionId;
    baseRequest.signCS = getSignChecksum(baseRequest.toString(), "");

    try {
      //  PopUpLoading.onLoading(Get.context!);
      var res = await dashboardRepo.logoutApi(baseRequest);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);
        if (response.responseCode == "0") {
          //   PopUpLoading.onLoadingOff(Get.context!);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(KeyConstants.isLoggedIn, false);
          clearAllSharedPreferences();
          print("go to login screen");
          Get.offAllNamed(Routes.loginScreen.name);
          print("logout");
          //  }
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          if (response.message == "Session Expired, Please Login again.") {
            sessionExpireHandle();
          } else {
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        }
      } else {
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    }
  }

  void checkForMultipleEntries(List<HoldingDataList>? holdingDataList) {
    Map<String, int> sectorCount =
        countBusinessSectorOccurrences(holdingDataList);

    sectorCount.forEach((businessSector, count) {
      if (count > 1) {
        print("Business sector '$businessSector' has $count entries.");
      } else {
        print("Business sector '$businessSector' has only one entry.");
      }
    });
  }

  Map<String, int> countBusinessSectorOccurrences(
      List<HoldingDataList>? holdingDataList) {
    Map<String, int> sectorCount = {};

    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      // Count occurrences of each business sector
      for (var holdingData in holdingDataList) {
        String businessSector =
            holdingData.companyData?.businessSector ?? 'Others';
        sectorCount[businessSector] = (sectorCount[businessSector] ?? 0) + 1;
      }
    }

    return sectorCount;
  }

  Map<String, BusinessSectorValue> calculateBusinessSectorTotalValue(
      List<HoldingDataList>? holdingDataList) {
    // Clear or re-initialize the map at the beginning of the method
    businessSectorTotalValues.clear();

    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      // Get the count of occurrences for each business sector
      Map<String, int> sectorCount =
          countBusinessSectorOccurrences(holdingDataList);

      // Calculate the total value for each sector
      for (var holdingData in holdingDataList) {
        String businessSector =
            holdingData.companyData?.businessSector ?? 'Others';
        double totalValue =
            double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;

        if (sectorCount[businessSector]! > 1) {
          // If the sector appears more than once, sum the total values
          if (businessSectorTotalValues.containsKey(businessSector)) {
            double currentTotal =
                businessSectorTotalValues[businessSector]!.totalValue;
            businessSectorTotalValues[businessSector] =
                BusinessSectorValue(currentTotal + totalValue, 0.0);
          } else {
            businessSectorTotalValues[businessSector] =
                BusinessSectorValue(totalValue, 0.0);
          }
          print(
              "Business sector '$businessSector' has ${sectorCount[businessSector]} entries.");
        } else {
          // If the sector appears only once, just set the total value
          businessSectorTotalValues[businessSector] =
              BusinessSectorValue(totalValue, 0.0);
          print("Business sector '$businessSector' has only one entry.");
        }
      }

      // Calculate the total sum of all sector values
      double totalSum = businessSectorTotalValues.values
          .map((value) => value.totalValue)
          .reduce((a, b) => a + b);

      // Calculate and set the percentage for each sector
      businessSectorTotalValues.forEach((key, value) {
        value.calculatePercentage(totalSum);
      });
    }

    return businessSectorTotalValues;
  }

/*  Map<String, BusinessSectorValue> calculateBusinessSectorTotalValue(List<HoldingDataList>? holdingDataList) {




    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      Map<String, int> sectorCount = countBusinessSectorOccurrences(holdingDataList);
   //   print("value here total val ${holdingDataList[10].totalValue }");
      // Calculate the total value for each sector
      for (var holdingData in holdingDataList) {
        String businessSector = holdingData.companyData?.businessSector ?? 'Others';
        double totalValue = double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;


        sectorCount.forEach((businessSector, count) {
          if (count > 1) {
            print("Business sector '$businessSector' has $count entries.");
            double currentTotal = businessSectorTotalValues[businessSector]!.totalValue;
            businessSectorTotalValues[businessSector] = BusinessSectorValue(currentTotal + totalValue, 0.0);
          } else {
            businessSectorTotalValues[businessSector] = BusinessSectorValue(totalValue, 0.0);
            print("Business sector '$businessSector' has only one entry.");
          }
        });

     /*   if (businessSectorTotalValues.containsKey(businessSector)) {

          double currentTotal = businessSectorTotalValues[businessSector]!.totalValue;
          print("current val ${currentTotal}");
          print("total val ${totalValue}");
          businessSectorTotalValues[businessSector] = BusinessSectorValue(currentTotal + totalValue, 0.0);

       //   print("value here total val9999999 ${currentTotal }");
          print("yess");
        } else {
          businessSectorTotalValues[businessSector] = BusinessSectorValue(totalValue, 0.0);
          print("yess111");
        }*/
      }

      // Calculate the total sum of all sector values
      double totalSum = businessSectorTotalValues.values.map((value) => value.totalValue).reduce((a, b) => a + b);

      // Calculate and set the percentage for each sector
      businessSectorTotalValues.forEach((key, value) {value.calculatePercentage(totalSum);});
    }

    return businessSectorTotalValues;
  }*/
}

class BusinessSectorValue {
  final double totalValue;
  double additionalValue;

  BusinessSectorValue(this.totalValue, this.additionalValue);
  void calculatePercentage(double totalSum) {
    additionalValue = (totalValue / totalSum) * 100;
  }
}
