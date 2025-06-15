import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:investor360/modules/dashboard/controller/dashboard_controller.dart';
import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataResponse.dart';
import 'package:investor360/modules/evoting/data/evoting_repo.dart';
import 'package:investor360/modules/evoting/model/cast_vote-request.dart';
import 'package:investor360/modules/evoting/model/evoting_event_resolution_list_response.dart'
    as resolutionEventList;
import 'package:investor360/modules/evoting/model/get_esp_list_request.dart';
import 'package:investor360/modules/evoting/model/get_esp_event_response.dart'
    as espResponse;
import 'package:investor360/modules/evoting/model/get_esp_url_request.dart';
import 'package:investor360/modules/evoting/model/get_evoting_event_resolution_list_Request.dart';
import 'package:investor360/modules/evoting/model/response_evoting_event_list.dart';
import 'package:investor360/modules/evoting/model/response_get_evoting_count.dart';
import 'package:investor360/modules/evoting/views/EvotingEspUrlWebView.dart';
import 'package:investor360/modules/portfolio/screens/others.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/loading/popup_loading.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/base_request.dart';
import 'package:investor360/utils/base_response.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:investor360/utils/session_handle.dart';
import 'package:investor360/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EvotingController extends GetxController {
  List<TextEditingController> votesCastControllers = [];
  List<int?> selectedValues = [];
  List<int> logArray = [];
  RxString selectedOption = ''.obs;
  RxString allSelectedOption = ''.obs;
  RxString dpIdResolution = ''.obs;
  RxString clientIdResolution = ''.obs;
  RxBool markAllInFavour = false.obs;
  RxBool markAllInAgainst = false.obs;
  RxBool resolution1Voted = true.obs;
  RxBool assent = false.obs;
  RxBool dissent = false.obs;
  RxBool clear = false.obs;
  List<Data> eventData = [];
  final EvotingRepo evotingRepo = EvotingRepo();
  DashboardController dashboardController = Get.put(DashboardController());
  var combinedList = <CombinedEvent>[].obs;

  var votingCycles = <EventList>[].obs;
  var evotingEventList = <Data>[].obs;
  var espEventLists = <espResponse.Data>[].obs;
  late WebViewController webViewController;
  // var combinedLists = <T>[].obs;
  // var combinedDataList = [].obs ;

  var evotingResolutionListData = <resolutionEventList.Data>[].obs;
//  var optionArrayData = <resolutionEventList.OptionsArray>[].obs;

  void updateRadioButton(String value) {
    selectedOption.value = value;
    if (value == "assent") {
      allSelectedOption.value = 'favour';
    } else if (value == "dissent") {
      allSelectedOption.value = 'against';
    } else {
      allSelectedOption.value = "";
    }
  }

  void resetAll() {
    selectedValues = List<int?>.filled(evotingResolutionListData.length, null);
    logArray = List<int>.filled(evotingResolutionListData.length, 0);
    votesCastControllers.forEach((controller) => controller.clear());
  }

  void updateMarkAllInFavour(String value) {
    if (value == "favour") {
      selectedOption.value = 'assent';
      allSelectedOption.value = "favour";
    } else {
      selectedOption.value = 'dissent';
      allSelectedOption.value = "against";
    }
  }

  void updateMarkAllInAgainst(bool isAgainstSelected) {
    if (isAgainstSelected) {
      selectedOption.value = 'dissent';
    }
  }

  void showEvotingBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      builder: (BuildContext context) {
        return EvotingBottomSheet();
      },
    );
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
                        showSnackBar(context, "You have voted Successfully");

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

  Future<void> getEvotingEventListApi() async {
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
      PopUpLoading.onLoading(Get.context!);

      var res = await evotingRepo.getEvotingEventList(baseRequest);
      print("Raw Response: ${res.data}");

      if (res != null && res.statusCode == 200) {
        Map<String, dynamic> mainJson;

        // If res.data is a String, decode it as JSON
        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else {
          mainJson = res.data;
        }

        if (mainJson['responseCode'] == "1" ||
            mainJson['responseCode'] == "-1") {
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        if (mainJson['data'] == null) {
          throw Exception('Data field is null');
        }

        // Handle case where 'data' might be a simple String or JSON
        if (mainJson['data'] is String) {
          // Attempt to decode the string if it's valid JSON, otherwise leave it as a string
          try {
            // Try decoding as JSON string
            mainJson['data'] = jsonDecode(mainJson['data']);
          } catch (e) {
            print('Data is a plain string, not JSON: ${mainJson['data']}');
            // Do nothing, keep data as plain string
          }
        }

        // Parse the response based on the 'data' field type
        if (mainJson['data'] is List) {
          // If data is a List, handle it accordingly
          List<dynamic> dataList = mainJson['data'];
          eventData = dataList.map((item) => Data.fromJson(item)).toList();

          ResponseEvotingEventList responseEventList =
              ResponseEvotingEventList(data: eventData);

          BaseResponse<ResponseEvotingEventList> response =
              BaseResponse.fromJson(mainJson, (_) => responseEventList);

          if (response.responseCode == "0") {
            print("Response data: " + response.data.toString());
            PopUpLoading.onLoadingOff(Get.context!);
            print("evoting event list API successful11");

            dpIdResolution.value = eventData[0].dpId.toString();
            clientIdResolution.value = eventData[0].clientId.toString();
            // Extract eventList from each Data object and combine them
            List<EventList> eventList =
                eventData.expand((data) => data.eventList!).toList();
            performComparison();

            // Assign to observable list
            votingCycles.assignAll(eventList);
            getESPEventListNewAPI();
            //  evotingEventList.assignAll(eventData);

            //   getEvotingEventResolutionListAPI();
          } else {
            PopUpLoading.onLoadingOff(Get.context!);
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        } else if (mainJson['data'] is Map<String, dynamic>) {
          // If data is a nested JSON object (Map), handle it accordingly
          BaseResponse<ResponseEvotingEventList> response =
              BaseResponse.fromJson(mainJson,
                  (dataJson) => ResponseEvotingEventList.fromJson(dataJson));

          if (response.responseCode == "0") {
            print("Response data: " + response.data.toString());
            PopUpLoading.onLoadingOff(Get.context!);
            print("evoting event list API successful22");
            //  getEvotingEventResolutionListAPI();
          } else {
            PopUpLoading.onLoadingOff(Get.context!);
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        } else {
          // Handle case where data is neither List nor Map
          throw Exception("Unexpected data format: ${mainJson['data']}");
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception: " + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  Future<void> getEvotingEventResolutionListAPI(
      String eventID, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }
    GetEvotingEventResolutionListRequest evenResolutionList =
        GetEvotingEventResolutionListRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      dpId: dpIdResolution.value,
      clientId: clientIdResolution.value,
      evenId: eventID,
    );
    evenResolutionList.signCS =
        getSignChecksum(evenResolutionList.toString(), "");
    try {
      PopUpLoading.onLoading(Get.context!);

      var res = await evotingRepo.getEvotingResolutionList(evenResolutionList);
      print(res);

      if (res != null && res.statusCode == 200) {
        Map<String, dynamic> mainJson;

        if (res.data is String) {
          mainJson = jsonDecode(res.data);
        } else {
          mainJson = res.data;
        }

        if (mainJson['responseCode'] == "1" ||
            mainJson['responseCode'] == "-1") {
          if (mainJson['message'] == "Session Expired, Please Login again.") {
            sessionExpireHandle();
            return;
          } else {
            showSnackBar(
                Get.context!, mainJson['message'] ?? "An error occurred");
            return;
          }
        }

        if (mainJson['data'] == null) {
          throw Exception('Data field is null');
        }

        if (mainJson['data'] is String) {
          try {
            mainJson['data'] = jsonDecode(mainJson['data']);
          } catch (e) {
            print('Data is a plain string, not JSON: ${mainJson['data']}');
          }
        }

        if (mainJson['data'] is List) {
          List<dynamic> dataList = mainJson['data'];
          List<resolutionEventList.Data> resolutionDataList = dataList
              .map((item) => resolutionEventList.Data.fromJson(item))
              .toList();

          resolutionEventList.EvotingEventResolutionListResponse
              resolutionListResponse =
              resolutionEventList.EvotingEventResolutionListResponse(
                  data: resolutionDataList);
          //   resolutionEventList.EvotingEventResolutionListResponse();

          BaseResponse<resolutionEventList.EvotingEventResolutionListResponse>
              response =
              BaseResponse.fromJson(mainJson, (_) => resolutionListResponse);

          if (response.responseCode == "0") {
            print("Response data: " + response.data.toString());
            PopUpLoading.onLoadingOff(Get.context!);
            print("evoting event resolution list API successful33");
            evotingResolutionListData.value = resolutionDataList;

            /*  List<resolutionEventList.OptionsArray> optionArrayList =
            resolutionDataList.expand((data) => data.optionsArray!).toList();


            optionArrayData.value.assignAll(optionArrayList);
            print('optionarraydata ${optionArrayData[2].optionName}');*/

            Get.toNamed(
              Routes.evotingDetail.name,
              arguments: {'index': index},
            );
          } else {
            PopUpLoading.onLoadingOff(Get.context!);
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        } else if (mainJson['data'] is Map<String, dynamic>) {
          BaseResponse<ResponseEvotingEventList> response =
              BaseResponse.fromJson(mainJson,
                  (dataJson) => ResponseEvotingEventList.fromJson(dataJson));

          if (response.responseCode == "0") {
            print("Response data: " + response.data.toString());
            PopUpLoading.onLoadingOff(Get.context!);
            print("evoting event resolution list API successful44");
          } else {
            PopUpLoading.onLoadingOff(Get.context!);
            showSnackBar(Get.context!, response.message ?? "An error occurred");
          }
        } else {
          // Handle case where data is neither List nor Map
          throw Exception("Unexpected data format: ${mainJson['data']}");
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  Future<void> castVoteAPI(String eventID, List<String> resolutionIds,
      List<String> optionIDs, List<int> votesCastList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    List<ResolutionDetail> resolutionDetails = [];

    for (int i = 0; i < resolutionIds.length; i++) {
      resolutionDetails.add(
        ResolutionDetail(
          resolutionId: resolutionIds[i],
          optionId: optionIDs[i],
          votesCast: votesCastList[i].toString(),
        ),
      );
    }

    CastVoteRequest evenResolutionList = CastVoteRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId,
      dpId: dpIdResolution.value,
      clientId: clientIdResolution.value,
      evenId: eventID,
      resolutionDetails: resolutionDetails,
    );

    evenResolutionList.signCS =
        getSignChecksum(evenResolutionList.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);

      var res = await evotingRepo.castVote(evenResolutionList);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

        if (response.responseCode == "0") {
          PopUpLoading.onLoadingOff(Get.context!);

          //String successMessage = response.message ?? "Vote cast ";

          showSnackBar(Get.context!, "Vote cast ");
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          PopUpLoading.onLoadingOff(Get.context!);

          String errorMessage = response.message ?? "An error occurred";
          if (response.data != null && response.data.isNotEmpty) {
            var firstError = response.data[0];
            if (firstError != null && firstError['message'] != null) {
              errorMessage = firstError['message'];
            }
          }
          showSnackBar(Get.context!, errorMessage);
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

/*
  Future<void> castVoteAPI(String eventID, List<String> resolutionIds,
      List<String> optionIDs, List<int> votesCastList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    List<ResolutionDetail> resolutionDetails = [];

    for (int i = 0; i < resolutionIds.length; i++) {
      resolutionDetails.add(
        ResolutionDetail(
          resolutionId: resolutionIds[i],
          optionId: optionIDs[i],
          votesCast: votesCastList[i].toString(),
        ),
      );
    }

    CastVoteRequest evenResolutionList = CastVoteRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId,
      dpId: dpIdResolution.value,
      clientId: clientIdResolution.value,
      evenId: eventID,
      resolutionDetails: resolutionDetails,
    );

    evenResolutionList.signCS =
        getSignChecksum(evenResolutionList.toString(), "");

    try {
      PopUpLoading.onLoading(Get.context!);

      var res = await evotingRepo.castVote(evenResolutionList);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

        if (response.responseCode == "0") {
          PopUpLoading.onLoadingOff(Get.context!);
          showSnackBar(Get.context!, "You have voted Successfully");
          // Handle successful response here
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          PopUpLoading.onLoadingOff(Get.context!);
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      PopUpLoading.onLoadingOff(Get.context!);
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }
*/

  Future<void> getESPEventListNewAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    GetEspListRequest evenResolutionList = GetEspListRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId,
      dpId: "IN487875",
      clientId: "12055001",
    );

    evenResolutionList.signCS =
        getSignChecksum(evenResolutionList.toString(), "");

    try {
      var res = await evotingRepo.getEspList(evenResolutionList);
      print(res);

      if (res != null && res.statusCode == 200) {
        var response = BaseResponse<dynamic>.fromJson(
          res.data,
          (data) {
            // Parse the response data
            if (data is String) {
              try {
                final parsedData = jsonDecode(data);
                if (parsedData is List) {
                  return parsedData
                      .map((item) => espResponse.Data.fromJson(item))
                      .toList();
                }
              } catch (e) {
                print("Error parsing data: $e");
                return null;
              }
            } else if (data is List) {
              return data
                  .map((item) => espResponse.Data.fromJson(item))
                  .toList();
            }
            return null;
          },
        );

        if (response.responseCode == "0") {
          List<espResponse.Data>? eventData = response.data;
          if (eventData != null) {
            espEventLists.assignAll(eventData); // Assign to observable list
            combineEventEspData();
          }
        } else {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print(e);
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  Future<void> getEspUrlAPI(String espCode, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    GetEspUrlRequest getEspUrlRequest = GetEspUrlRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      dpId: "IN487875",
      clientId: "12055001",
      espCode: espCode,
    );

    getEspUrlRequest.signCS = getSignChecksum(getEspUrlRequest.toString(), "");

    try {
      var res = await evotingRepo.getEspUrl(getEspUrlRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        // Parse the response
        var response = BaseResponse<dynamic>.fromJson(
          res.data,
          (data) {
            if (data is String) {
              try {
                final parsedData = jsonDecode(data);
                return parsedData;
              } catch (e) {
                print("Error parsing data: $e");
                return null;
              }
            } else if (data is Map<String, dynamic>) {
              return data;
            }
            return null;
          },
        );

        if (response.responseCode == "0") {
          String? url = response.data['url'];
          String? data = response.data['data'];
          String? source_entity_id = response.data['source_entity_id'];
          if (url != null) {
            print("ESP URL: $url");

            Get.to(EvotingEspUrlWebViewPage(
              sData: data.toString(),
              sEntityId: source_entity_id.toString(),
              sURL: url.toString(),
            ));
            //  sendFormData(data, source_entity_id, url);
          } else {
            showSnackBar(Get.context!, "URL not found in the response");
          }
        } else {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print(e);
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  void launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar(context, "Could not launch $url");
    }
  }

  Future<void> sendFormData(
      String? data, String? sourceEntityId, String urls) async {
    dio.Dio dioClient = dio.Dio();

    String url = urls.toString();

    dio.FormData formData = dio.FormData.fromMap({
      'data': data.toString(),
      'source_entity_id': sourceEntityId.toString(),
    });

    try {
      dio.Response response = await dioClient.post(url, data: formData);

      //launchUrl(context, url);

      // Print the response or handle it accordingly
      print('Response data: ${response.data}');
    } on dio.DioError catch (e) {
      // Handle error
      print('Error: ${e.response?.data}');
    }
  }

  String formatDateString(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formateDate = DateFormat('dd-MM-yyyy').format(dateTime);
      return formateDate;
    } catch (e) {
      return dateString;
    }
  }

  void combineEventEspData() {
    List<CombinedEvent> combinedData = [];

    for (var votingEvent in votingCycles) {
      combinedData.add(CombinedEvent(
        isin: votingEvent.isin.toString(),
        evenId: votingEvent.evenId.toString(),
        company: votingEvent.company.toString(),
        issuerName: "",
        cycleEndDate: votingEvent.cycleEndDate.toString(),
        eventEndDate: '',
        espCode: '1',
        totalPosition: null,
      ));
    }

    for (var espEvent in espEventLists) {
      combinedData.add(CombinedEvent(
        isin: espEvent.isin.toString(),
        evenId: espEvent.evenId.toString(),
        company: "",
        issuerName: espEvent.issuerName.toString(),
        cycleEndDate: '',
        eventEndDate: formatDateString(espEvent.eventEndDate.toString()),
        espCode: espEvent.espCode.toString(),
        totalPosition: null, // Initialize as null
      ));
    }

    combinedList.assignAll(combinedData);

    Map<String, double> totalPositions = compareISINAndStoreTotalPosition(
        eventData.expand((data) => data.eventList!).toList(),
        dashboardController.shareee);

    for (var combinedEvent in combinedList) {
      if (totalPositions.containsKey(combinedEvent.isin)) {
        combinedEvent.totalPosition = totalPositions[combinedEvent.isin]!;
      }
    }

    print("Combined List:");
    for (var combinedEvent in combinedList) {
      print(combinedEvent.toString());
    }
  }

  Map<String, double> compareISINAndStoreTotalPosition(
      List eventList, List<HoldingDataList> displayHoldingDataList) {
    Map<String, double> totalPositions = {};

    for (var event in eventList) {
      for (var holding in displayHoldingDataList) {
        if (event.isin == holding.isin) {
          totalPositions[event.isin] = holding.totalPosition;
        }
        print("The Total Position is $totalPositions");
      }
    }

    return totalPositions;
  }

  void performComparison() {
    List<HoldingDataList> displayHoldingDataList = dashboardController.shareee;
    print("The holding list is: $displayHoldingDataList");

    List<EventList> eventList =
        eventData.expand((data) => data.eventList!).toList();
    print("The event list is: $eventList");

    Map<String, double> totalPositions =
        compareISINAndStoreTotalPosition(eventList, displayHoldingDataList);

    print("Total Positions: $totalPositions");

    for (var combinedEvent in combinedList) {
      if (totalPositions.containsKey(combinedEvent.isin)) {
        combinedEvent.totalPosition = totalPositions[combinedEvent.isin]!;
        print(
            "Updated CombinedEvent: ISIN: ${combinedEvent.isin}, Total Position: ${combinedEvent.totalPosition}");
      } else {
        print(
            "No matching ISIN for CombinedEvent: ${combinedEvent.isin}, keeping previous totalPosition: ${combinedEvent.totalPosition}");
      }
    }

    print("Combined list after updating total positions: $combinedList");
  }
}

class EvotingBottomSheet extends StatefulWidget {
  EvotingBottomSheet({super.key});

  @override
  State<EvotingBottomSheet> createState() => _EvotingBottomSheetState();
}

class _EvotingBottomSheetState extends State<EvotingBottomSheet> {
  final EvotingRepo evotingRepo = EvotingRepo();

  int responseVotes = 0;
  int count = 0;
  int totalCount = 0;
  String numberOfCounts = "";
  bool isLoading = false; // Introduce isLoading variable

  @override
  void initState() {
    calculateTotalValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);

    // If isLoading is true, return an empty Container (or a loading indicator)
    if (isLoading) {
      return const SizedBox();
    }

    // If isLoading is false, return the actual content
    return SizedBox(
      height: 350,
      child: WillPopScope(
        onWillPop: () async {
          Get.back();
          return true;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                child: Text(
                  "Confirmation",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: darkMode ? Colors.white : const Color(0xFF434343),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'There are ',
                      ),
                      TextSpan(
                        text:
                            numberOfCounts, // Display the total number of counts
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' E-voting cycles available.\nWould you like to review and cast vote.\nKindly ignore if already done',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.eVoting.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkMode
                        ? NsdlInvestor360Colors.buttonDarkcolour
                        : NsdlInvestor360Colors.bottomCardHomeColour2,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> calculateTotalValue() async {
    try {
      isLoading = true;
      // Await both API calls to complete
      await getEvotingCountApi();
      await getESPEventListAPI();

      // Calculate the total value
      totalCount = count + responseVotes;
      numberOfCounts = totalCount.toString();

      // Use addPostFrameCallback to ensure that UI updates happen after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          numberOfCounts = totalCount.toString(); // Convert to String
          isLoading = false; // Stop loading
        });
      });
    } catch (e) {
      print("Error while calculating total value: $e");
      // Handle error if needed
    } finally {
      isLoading = false;
    }
  }

  Future<void> getEvotingCountApi() async {
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
      var res = await evotingRepo.getEvotingCount(baseRequest);
      print(res);

      if (res != null && res.statusCode == 200) {
        CommonBaseResponse response = CommonBaseResponse.fromJson(res.data);

        if (response.responseCode == "0") {
          List<dynamic> dataList = json.decode(response.data!) as List<dynamic>;

          // Now you can parse the first element as your response class
          GetEvotingCountResponse evotingCountResponse =
              GetEvotingCountResponse.fromJson(dataList[0]);

          responseVotes =
              evotingCountResponse.totalVotes ?? 0; // Fetch total votes safely
        } else if (response.responseCode == "1" ||
            response.responseCode == "-1") {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print("#Exception" + e.toString());
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }

  Future<void> getESPEventListAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(KeyConstants.sessionId);

    if (sessionId == null) {
      showSnackBar(Get.context!, "Session ID not found.");
      return;
    }

    GetEspListRequest evenResolutionList = GetEspListRequest(
      channelId: "Device",
      deviceId: await getDeviceId(),
      deviceOS: getDeviceOS(),
      sessionId: sessionId!,
      dpId: "IN487875",
      clientId: "12055001",
    );

    evenResolutionList.signCS =
        getSignChecksum(evenResolutionList.toString(), "");

    try {
      var res = await evotingRepo.getEspList(evenResolutionList);
      print(res);

      if (res != null && res.statusCode == 200) {
        // Parse the response
        var response = BaseResponse<dynamic>.fromJson(
          res.data,
          (data) {
            // Check if data is a string and parse it if necessary
            if (data is String) {
              try {
                // Attempt to parse the string into a JSON list
                final parsedData = jsonDecode(data);
                if (parsedData is List) {
                  return parsedData
                      .map((item) => espResponse.Data.fromJson(item))
                      .toList();
                }
              } catch (e) {
                print("Error parsing data: $e");
                return null;
              }
            } else if (data is List) {
              return data
                  .map((item) => espResponse.Data.fromJson(item))
                  .toList();
            }
            return null;
          },
        );

        if (response.responseCode == "0") {
          List<espResponse.Data>? eventData = response.data;
          print("ESP Event List: $eventData");
          count = eventData!.where((event) => event.espCode != '1').length;

          // Display the count
          print("Count of espCode not equal to 1: $count");
        } else {
          showSnackBar(Get.context!, response.message ?? "An error occurred");
        }
      }
    } catch (e) {
      print(e);
      showSnackBar(Get.context!, "Failed to load data");
      throw Exception('Failed to load data');
    }
  }
}

class CombinedEvent {
  final String isin;
  final String evenId;
  final String issuerName;
  final String company;
  final String cycleEndDate;
  final String eventEndDate;
  final String espCode;
  double? totalPosition;

  CombinedEvent({
    required this.isin,
    required this.evenId,
    required this.issuerName,
    required this.company,
    required this.cycleEndDate,
    required this.eventEndDate,
    required this.espCode,
    this.totalPosition,
  });

  @override
  String toString() {
    return '$company $issuerName';
  }
}
