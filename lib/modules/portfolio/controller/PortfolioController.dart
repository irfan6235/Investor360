import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:investor360/utils/base_request.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes.dart';
import '../../../shared/loading/popup_loading.dart';
import '../../../utils/base_response.dart';
import '../../../utils/string_constants.dart';
import '../../dashboard/data/dashboard_repo.dart';
import '../../dashboard/model/GetNsdlHoldingDataRequest.dart';
import '../../dashboard/model/GetNsdlHoldingDataResponse.dart';

class PortfolioController extends GetxController {
  var isLoading = false.obs;
  final DashboardRepo dashboardRepo = DashboardRepo();
  Rx<GetNsdlHoldingDataResponse?> responseData =
      Rx<GetNsdlHoldingDataResponse?>(null);

  List<HoldingDataList> aggregatedHoldings = [];
  dynamic selectedClientId = "ALL".obs;

  TextEditingController textEditingControllerBeneidEquity =
      TextEditingController();
  TextEditingController textEditingControllerBeneidMF = TextEditingController();
  TextEditingController textEditingControllerBeneidDebt =
      TextEditingController();
  TextEditingController textEditingControllerBeneidOthers =
      TextEditingController();

  TextEditingController searchBarEquityController = TextEditingController();
  TextEditingController searchBarMFController = TextEditingController();
  TextEditingController searchBarDebtController = TextEditingController();
  TextEditingController searchBarOtherController = TextEditingController();

  var filteredHoldings = <HoldingDataList>[].obs;

  var isEquityDataLoaded = false.obs;
  var isMfDataLoaded = false.obs;
  var isDebtDataLoaded = false.obs;
  var isOthersDataLoaded = false.obs;

  RxDouble equityValuePortfolio = 0.0.obs;
  RxDouble mFValuePortfolio = 0.0.obs;
  RxDouble deptValuePortfolio = 0.0.obs;
  RxDouble othersValuePortfolio = 0.0.obs;
  var isPortfolioDataLoaded = false.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchNsdlHoldingDataApiPortfolio();
  }

  Future<void> fetchNsdlHoldingDataApiPortfolio() async {
    GetNsdlHoldingDataRequest getNsdlHoldingDataRequest =
        GetNsdlHoldingDataRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString(KeyConstants.sessionId);

    getNsdlHoldingDataRequest.channelId = "Device";
    getNsdlHoldingDataRequest.deviceId = await getDeviceId();
    getNsdlHoldingDataRequest.deviceOS = getDeviceOS();
    getNsdlHoldingDataRequest.sessionId = sessionId;
    getNsdlHoldingDataRequest.signCS =
        getSignChecksum(getNsdlHoldingDataRequest.toString(), "");

    try {
      // PopUpLoading.onLoading(Get.context!);
      isLoading.value = true;
      var res =
          await dashboardRepo.getNsdlHoldingDataApi(getNsdlHoldingDataRequest);

      if (res != null && res.statusCode == 200) {
        // Ensure res.data is not null and is a String or Map
        if (res.data == null) {
          throw Exception('Response data is null');
        }

        Map<String, dynamic> mainJson;
        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else {
          mainJson = res.data;
        }

        // Check the response code before processing 'data' field
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
          initializeFilteredHoldings();
          calculateSecurityTotalValue(filteredHoldings.value);
          isPortfolioDataLoaded.value = true;

          if (responseData.value != null &&
              responseData.value!.holdingDataList != null) {
            aggregatedHoldings =
                aggregateHoldings(responseData.value!.holdingDataList!);
          } else {
            aggregatedHoldings = [];
          }

          isEquityDataLoaded.value = true;
          isMfDataLoaded.value = true;
          isDebtDataLoaded.value = true;
          isOthersDataLoaded.value = true;

          print(responseData.value);
        } else {
          //PopUpLoading.onLoadingOff(Get.context!);
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      } else {
        //   PopUpLoading.onLoadingOff(Get.context!);
        showSnackBar(Get.context!,
            "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      showSnackBar(Get.context!, "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

/*  Future<void> fetchNsdlHoldingDataApiPortfolio() async {
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

        // Extract and decode the nested JSON string in the 'data' field
        Map<String, dynamic> nestedJson = jsonDecode(mainJson['data']);

        // Replace the 'data' field in the main JSON with the nested JSON
        mainJson['data'] = nestedJson;

        // Parse the BaseResponse
        BaseResponse<GetNsdlHoldingDataResponse> response = BaseResponse.fromJson(
          mainJson,
              (dataJson) => GetNsdlHoldingDataResponse.fromJson(dataJson),
        );

        if (response.responseCode == "0") {
          print("Response data: " + response.data.toString());

          responseData.value = response.data;
        initializeFilteredHoldings();
        calculateSecurityTotalValue(filteredHoldings.value);
        isPortfolioDataLoaded.value = true;

        if (responseData.value != null &&
            responseData.value!.holdingDataList != null) {
          aggregatedHoldings =
              aggregateHoldings(responseData.value!.holdingDataList!);
        } else {
          aggregatedHoldings = [];
        }

        isEquityDataLoaded.value = true;
        isMfDataLoaded.value = true;
        isDebtDataLoaded.value = true;
        isOthersDataLoaded.value = true;

        print(responseData.value);
        } else {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      } else {
        showSnackBar(Get.context!, "Failed to fetch data. Status code: ${res?.statusCode}");
      }
    } catch (e) {
      print("#Exception: $e");
      throw Exception('Failed to load data: $e');
    } finally {
      PopUpLoading.onLoadingOff(Get.context!);
    }
  }*/

  void initializeFilteredHoldings() {
    if (responseData.value != null &&
        responseData.value!.holdingDataList != null) {
      filteredHoldings.value =
          aggregateHoldings(responseData.value!.holdingDataList!);
    } else {
      filteredHoldings.value = [];
    }
  }

  List<HoldingDataList> aggregateHoldings(List<HoldingDataList> holdings) {
    Map<String, HoldingDataList> aggregatedHoldings = {};
    for (var holding in holdings) {
      if (aggregatedHoldings.containsKey(holding.isin)) {
        aggregatedHoldings[holding.isin]!.totalPosition +=
            holding.totalPosition;

        aggregatedHoldings[holding.isin]!.totalValue = (double.tryParse(
                    aggregatedHoldings[holding.isin]!.totalValue ?? '0')! +
                double.tryParse(holding.totalValue ?? '0')!)
            .toString();

/*        aggregatedHoldings[holding.isin]!.closingPrice ??= 0.0;
        aggregatedHoldings[holding.isin]!.closingPrice += holding.closingPrice;*/

        aggregatedHoldings[holding.isin]!.unlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.unlockBalance +=
            holding.unlockBalance;

        aggregatedHoldings[holding.isin]!.blockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.blockBalance += holding.blockBalance;

        aggregatedHoldings[holding.isin]!.lockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.lockBalance += holding.lockBalance;

        aggregatedHoldings[holding.isin]!.dematUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.dematUnlockBalance +=
            holding.dematUnlockBalance;

        aggregatedHoldings[holding.isin]!.rematUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.rematUnlockBalance +=
            holding.rematUnlockBalance;

        aggregatedHoldings[holding.isin]!.rematLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.rematLockBalance +=
            holding.rematLockBalance;

        aggregatedHoldings[holding.isin]!.pledgeUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeUnlockBalance +=
            holding.pledgeUnlockBalance;

        aggregatedHoldings[holding.isin]!.pledgeLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeLockBalance +=
            holding.pledgeLockBalance;

        aggregatedHoldings[holding.isin]!.pledgeTransitUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeTransitUnlockBalance +=
            holding.pledgeTransitUnlockBalance;

        aggregatedHoldings[holding.isin]!.pledgeTransitLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeTransitLockBalance +=
            holding.pledgeTransitLockBalance;

        aggregatedHoldings[holding.isin]!.holdLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdLockBalance +=
            holding.holdLockBalance;

        aggregatedHoldings[holding.isin]!.holdTransitLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdTransitLockBalance +=
            holding.holdTransitLockBalance;

        aggregatedHoldings[holding.isin]!.holdTransitUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdTransitUnlockBalance +=
            holding.holdTransitUnlockBalance;

        aggregatedHoldings[holding.isin]!.holdUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdUnlockBalance +=
            holding.holdUnlockBalance;
      } else {
        aggregatedHoldings[holding.isin] = HoldingDataList(
          dpId: holding.dpId,
          clientId: holding.clientId,
          securityType: holding.securityType,
          isin: holding.isin,
          totalPosition: holding.totalPosition,
          totalValue: holding.totalValue,
          companyName: holding.companyName,
          closingPrice: holding.closingPrice ?? '0',
          unlockBalance: holding.unlockBalance ?? 0.0,
          blockBalance: holding.blockBalance ?? 0.0,
          lockBalance: holding.lockBalance ?? 0.0,
          dematUnlockBalance: holding.dematUnlockBalance ?? 0.0,
          rematUnlockBalance: holding.rematUnlockBalance ?? 0.0,
          rematLockBalance: holding.rematLockBalance ?? 0.0,
          pledgeUnlockBalance: holding.pledgeUnlockBalance ?? 0.0,
          pledgeLockBalance: holding.pledgeLockBalance ?? 0.0,
          pledgeTransitUnlockBalance: holding.pledgeTransitUnlockBalance ?? 0.0,
          pledgeTransitLockBalance: holding.pledgeTransitLockBalance ?? 0.0,
          holdLockBalance: holding.holdLockBalance ?? 0.0,
          holdTransitLockBalance: holding.holdTransitLockBalance ?? 0.0,
          holdTransitUnlockBalance: holding.holdTransitUnlockBalance ?? 0.0,
          holdUnlockBalance: holding.holdUnlockBalance ?? 0.0,
        );
      }
    }
    return aggregatedHoldings.values.toList();
  }

/*
  List<HoldingDataList> aggregateHoldings(List<HoldingDataList> holdings) {
    Map<String, HoldingDataList> aggregatedHoldings = {};
    for (var holding in holdings) {
      if (aggregatedHoldings.containsKey(holding.isin)) {

        print("Total POS PRICE ${holding.totalPosition}");
        print("Toatal POS PRICE2 ${aggregatedHoldings[holding.isin]!.totalPosition}");

        print("CLOSING PRICE ${holding.lockBalance}");
        print("CLOSING PRICE2 ${aggregatedHoldings[holding.isin]!.lockBalance}");


        aggregatedHoldings[holding.isin]!.totalPosition += holding.totalPosition;

        aggregatedHoldings[holding.isin]!.totalValue =
            (double.tryParse(aggregatedHoldings[holding.isin]!.totalValue ?? '0')! +
                double.tryParse(holding.totalValue ?? '0')!).toString();








        aggregatedHoldings[holding.isin]!.unlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.unlockBalance += holding.unlockBalance;

        aggregatedHoldings[holding.isin]!.blockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.blockBalance += holding.blockBalance;

        aggregatedHoldings[holding.isin]!.lockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.lockBalance += holding.lockBalance;

        aggregatedHoldings[holding.isin]!.dematUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.dematUnlockBalance += holding.dematUnlockBalance;

        aggregatedHoldings[holding.isin]!.rematUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.rematUnlockBalance += holding.rematUnlockBalance;

        aggregatedHoldings[holding.isin]!.rematLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.rematLockBalance += holding.rematLockBalance;



        aggregatedHoldings[holding.isin]!.pledgeUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeUnlockBalance += holding.pledgeUnlockBalance;


        aggregatedHoldings[holding.isin]!.pledgeLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeLockBalance += holding.pledgeLockBalance;


        aggregatedHoldings[holding.isin]!.pledgeTransitUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeTransitUnlockBalance += holding.pledgeTransitUnlockBalance;


        aggregatedHoldings[holding.isin]!.pledgeTransitLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.pledgeTransitLockBalance += holding.pledgeTransitLockBalance;


        aggregatedHoldings[holding.isin]!.holdLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdLockBalance += holding.holdLockBalance;


        aggregatedHoldings[holding.isin]!.holdTransitLockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdTransitLockBalance += holding.holdTransitLockBalance;

        aggregatedHoldings[holding.isin]!.holdTransitUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdTransitUnlockBalance += holding.holdTransitUnlockBalance;

        aggregatedHoldings[holding.isin]!.holdUnlockBalance ??= 0.0;
        aggregatedHoldings[holding.isin]!.holdUnlockBalance += holding.holdUnlockBalance;

      } else {
        aggregatedHoldings[holding.isin] = HoldingDataList(
          dpId: holding.dpId,
          clientId: holding.clientId,
          securityType: holding.securityType,
          isin: holding.isin,
          totalPosition: holding.totalPosition,
          totalValue: holding.totalValue,
          closingPrice: holding.closingPrice ?? 0.0,
          companyName: holding.companyName,
          // Ensure unlockBalance is initialized
          unlockBalance: holding.unlockBalance ?? 0.0,
        );
      }
    }
    return aggregatedHoldings.values.toList();
  }*/

  void filterHoldingsByDPIDAndClientID(
      var dpId, var clientId, String securityType) {
    if (responseData.value != null &&
        responseData.value!.holdingDataList != null) {
      if (dpId == "ALL") {
        selectedClientId.value = "ALL";
        filteredHoldings.value = aggregateHoldings(responseData
            .value!.holdingDataList!
            .where((holding) => holding.securityType == securityType)
            .toList());

        searchBarEquityController.clear();
        searchBarMFController.clear();
        searchBarDebtController.clear();
        searchBarOtherController.clear();
        print("here1");
      } else if (dpId == null || clientId == null) {
        filteredHoldings.value = [];
        selectedClientId.value = "";
        print("here4");
      } else {
        filteredHoldings.value =
            responseData.value!.holdingDataList!.where((holding) {
          return holding.dpId == dpId &&
              holding.clientId == clientId &&
              holding.securityType == securityType;
        }).toList();
        print(filteredHoldings.value.toString());
        selectedClientId.value = clientId.toString();
        print("here2");
      }
    } else {
      filteredHoldings.value = [];
      print("here3");
    }
    calculateSecurityTotalValueWithSecurity(
        filteredHoldings.value, securityType);
  }

  void calculateSecurityTotalValueWithSecurity(
      List<HoldingDataList>? holdingDataList, String securityTypeToUpdate) {
    double totalValue = 0.0;

    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      for (var holdingData in holdingDataList) {
        if (holdingData.securityType == securityTypeToUpdate) {
          totalValue += double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;
        }
      }
    }

    switch (securityTypeToUpdate) {
      case 'MUTUAL_FUNDS':
        mFValuePortfolio.value = totalValue;
        break;
      case 'EQUITY':
        equityValuePortfolio.value = totalValue;
        break;
      case 'DEBT':
        deptValuePortfolio.value = totalValue;
        break;
      default:
        othersValuePortfolio.value = totalValue;
        break;
    }

    print("$securityTypeToUpdate totalValue: $totalValue");
    update();
  }

  void calculateSecurityTotalValue(List<HoldingDataList>? holdingDataList) {
    if (holdingDataList != null && holdingDataList.isNotEmpty) {
      double mutualFundsTotal = 0.0;
      double equityTotal = 0.0;
      double debtTotal = 0.0;
      double othersTotal = 0.0;

      for (var holdingData in holdingDataList) {
        final double totalValue =
            double.tryParse(holdingData.totalValue ?? '0') ?? 0.0;

        switch (holdingData.securityType) {
          case 'MUTUAL_FUNDS':
            mutualFundsTotal += totalValue;
            break;
          case 'EQUITY':
            equityTotal += totalValue;
            break;
          case 'DEBT':
            debtTotal += totalValue;
            break;
          default:
            othersTotal += totalValue;
            break;
        }
      }

      mFValuePortfolio.value = mutualFundsTotal;
      equityValuePortfolio.value = equityTotal;
      deptValuePortfolio.value = debtTotal;
      othersValuePortfolio.value = othersTotal;
      update();

      print("MUTUAL_FUNDS totalValue: $mutualFundsTotal");
      print("EQUITY totalValue: $equityTotal");
      print("DEBT totalValue: $debtTotal");
      print("OTH totalValue: $othersTotal");
    }

    update();
  }

  void searchFilterHoldings(String query) {
    if (query.isEmpty) {
      // Check if selectedClientId is "ALL"
      if (selectedClientId == "ALL") {
        // Return the aggregated list when selectedClientId is "ALL"
        filteredHoldings.value = aggregatedHoldings;
        print("here1111111");
      } else {
        // No search query, return the original holding list
        //  filteredHoldings.value = responseData?.value?.holdingDataList ?? [];

        filteredHoldings.value =
            responseData?.value?.holdingDataList?.where((holding) {
                  final companyName = holding.companyName.toLowerCase();
                  return holding.clientId ==
                          int.parse(selectedClientId.toString()) &&
                      companyName.contains(query.toLowerCase());
                }).toList() ??
                [];

        //   filteredHoldings.value = responseData.value!.holdingDataList!.where((holding) => holding.securityType == "EQUITY").toList();

        print("here2222222");
      }
    } else {
      // Apply both selectedClientId and query filter when query is not empty
      if (selectedClientId == "ALL") {
        // Filter the aggregated list when selectedClientId is "ALL" and query is not empty
        filteredHoldings.value = aggregatedHoldings.where((holding) {
          final companyName = holding.companyName.toLowerCase();
          return companyName.contains(query.toLowerCase());
        }).toList();
        print("here3333333");
      } else {
        // Filter the original holding list by selectedClientId and query
        filteredHoldings.value =
            responseData?.value?.holdingDataList?.where((holding) {
                  final companyName = holding.companyName.toLowerCase();
                  return holding.clientId ==
                          int.parse(selectedClientId.toString()) &&
                      companyName.contains(query.toLowerCase());
                }).toList() ??
                [];
        print("here4444444");
      }
    }
  }
}
