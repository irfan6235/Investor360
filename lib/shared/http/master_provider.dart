
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:investor360/utils/string_constants.dart';
import '../../environment/env.dart';
import '../../utils/common_utils.dart';
import '../../utils/error_dialog.dart';
import '../../utils/investor360_common_dialog.dart';
import 'api_exception.dart';
import 'http_headers.dart';

abstract class IMasterProvider {
  Future get(String resourceUrl);
  Future post(String resourceUrl, var requestModel);
  Future patch(String resourceUrl, var requestModel);
}

class MasterProvider implements IMasterProvider {
  Dio? dio = Dio();

  String baseUrl = Env.END_POINT;

  @override
  get(String endPoint) async {
    String resourceUrl = baseUrl + endPoint;
    // Map<String, dynamic> headers = await GetHTTPHeaders?.getHeaders();

    print("API Url");
    print(resourceUrl);
    // print("Headers");
    // print(headers);

    try {
      final response = await dio?.get(
        resourceUrl,
        // options: Options(headers: headers),
      );
      log(response!.data!.toString());
      return handleResponse(response, endPoint);
    } on DioError catch (e) {
      final errorMessage = ApiException.fromDioError(e).toString();
      return errorMessage;
    }
  }

  Future post(String endPoint, dynamic requestModel, [bool? isByte]) async {
    String resourceUrl = baseUrl + endPoint;
    Map<String, dynamic> headers = await GetHTTPHeaders.getHeaders();
    print("API Url");
    print(resourceUrl);
    print("API Request");
    print(json.encode(requestModel));

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showSnackBar(Get.context!, 'No internet connection');
      throw DioError(error: 'No internet connection', requestOptions: null!);
    }

    try {
      var dio = Dio(BaseOptions(
          baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ));

      final response = await dio.post(
        resourceUrl,
        data: requestModel,
        options: Options(
          responseType: isByte == true ? ResponseType.bytes : ResponseType.json,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print("Response: ${response.data}");
      return response;
    } on DioError catch (e) {
      final errorMessage = ApiException.fromDioError(e).toString();
      showSnackBar(Get.context!, errorMessage);
      throw e; // Rethrow the DioError for handling upstream
    }
  }

/*

  @override
  Future post(String endPoint, dynamic requestModel, [bool? isByte]) async {
    String resourceUrl = baseUrl + endPoint;
     Map<String, dynamic> headers = await GetHTTPHeaders.getHeaders();
    print("API Url");
    print(resourceUrl);
    print("API Request");
    print(json.encode(requestModel));

    try {
      var dio = Dio(BaseOptions(baseUrl: baseUrl));

      final response = await dio.post(
        resourceUrl,
        data: requestModel,
          options: Options( responseType: isByte == true ? ResponseType.bytes : ResponseType.json  , headers: {'Content-Type': 'application/json'},),
      );

      log("Response: " + response.data.toString());
      return response; //handleResponse(response, endPoint);
    } on DioError catch (e) {
      final errorMessage = ApiException.fromDioError(e).toString();
      showSnackBar(Get.context!, errorMessage);
      return errorMessage;
    }
  }
*/



  @override
  Future patch(String endPoint, requestModel) async {
    String resourceUrl = baseUrl + endPoint;
    Map<String, dynamic> headers = await GetHTTPHeaders.getHeaders();

    try {
      final response = await dio?.patch(
        resourceUrl,
        data: requestModel,
        options: Options(headers: headers),
      );
      log(response!.data!.toString());
      return handleResponse(response, endPoint);
    } on DioError catch (e) {
      final errorMessage = ApiException.fromDioError(e).toString();
      return errorMessage;
    }
  }

  dynamic handleResponse(dynamic response, String apiType) {
    try {
      String res = response.data.toString();
      if (res.isNotEmpty &&
          res.toLowerCase().contains("validations failed,1")) {
        Get.back();
        Get.dialog(ErrorDialog(message: Error.E013, isExpired: false),
            barrierDismissible: false);
        // return Error.E013;
      }
      else if (res == "{}") {
        Get.back();
        Get.dialog(
            const ErrorDialog(
                message: 'Empty JSON Response', isExpired: false));
        // return "Empty JSON Response";
      }
      else if (res.contains('URL was rejected')) {
        Get.back();
        Get.dialog(ErrorDialog(message: Error.COMMON_PART_2, isExpired: false),
            barrierDismissible: false);
      }
      else if (res.contains('V_RESPCODE')) {
        String respMessage = response.data['V_RESPONSE'];
        String respCode = response.data['V_RESPCODE'];
        if (respCode == ResponseCode.code_00) {
          return response;
        }
        /*  if (isSuccessful(respCode, response.data.toString(), apiType)) {
            return response;
          }*/
        else if (respCode == ResponseCode.code_01 ||
            respCode == ResponseCode.code_02 ||
            respCode == ResponseCode.code_06 ||
            respCode == ResponseCode.code_07 ||
            respCode == ResponseCode.code_08 ||
            respCode == ResponseCode.code_99) {
          Get.back();
          Get.dialog(ErrorDialog(message: respMessage, isExpired: false),
              barrierDismissible: false);
        }
        else if (respCode == ResponseCode.code_12) {
          Get.back();
          Get.dialog(
              const ErrorDialog(
                message: 'Your login session has been timed out, please login again',
                isExpired: true,),
              barrierDismissible: false);
          // return 'Your login session has been timed out, please login again';
        }
        else if (respCode == ResponseCode.code_15) {
          Get.back();
          Get.dialog(const ErrorDialog(
              message: 'You logged in on other device', isExpired: true),
              barrierDismissible: false);
          // return 'You logged in on other device';
        }
        else if (respCode == ResponseCode.code_14) {
          Get.back();
          Get.dialog(
              ErrorDialog(message: Error.CHECKSUM_FAILED, isExpired: false),
              barrierDismissible: false);
          // return Error.CHECKSUM_FAILED;
        }
        /* else if (respCode == ResponseCode.code_22) {
            if(apiType == ApiUrlEndpoint.userMBAppLogin){
              return response;
            } else {
              Get.back();
              Get.dialog(ErrorDialog(message: respMessage, isExpired: false), barrierDismissible: false);
            }
          }*/
        else
        if (respMessage.toLowerCase().contains("channel validation failed")) {
          Get.back();
          Get.dialog(
              ErrorDialog(message: Error.CHECKSUM_FAILED, isExpired: false),
              barrierDismissible: false);
          // return Error.CHECKSUM_FAILED;
        } else {
          Get.back();
          Get.dialog(ErrorDialog(message: respMessage, isExpired: false),
              barrierDismissible: false);
          // return 'Unhandled_$respCode';
        }
      }
      else if (res.contains('mbapploginresp')) {
        return response;
      }
      else {
        dynamic respMessage = response.data['response'];
        String respCode = response.data['respcode'];
        if (respCode == ResponseCode.code_00) {
          return response;
        }
        /* if (isSuccessful(respCode, response.data.toString(), apiType)) {
            return response;
          }*/
        else if (respCode == ResponseCode.code_01 ||
            respCode == ResponseCode.code_02 ||
            respCode == ResponseCode.code_06 ||
            respCode == ResponseCode.code_07 ||
            respCode == ResponseCode.code_08 ||
            respCode == ResponseCode.code_99) {
          Get.back();
          Get.dialog(ErrorDialog(message: respMessage, isExpired: false),
              barrierDismissible: false);
        }

        //? Error for 02M code // Do not honour
        else if (respCode == ResponseCode.code_02M) {
          Get.back();
          Future.delayed(Duration.zero, () {
            Get.dialog(Investor360CommonDialog(
                message: respMessage, buttonText: 'OK', onButtonTap: () {
              Get.back();
            }));
          });
        }
        else if (respCode == ResponseCode.code_12) {
          Get.back();
          Get.dialog(
              const ErrorDialog(
                message: 'Your login session has been timed out, please login again',
                isExpired: true,),
              barrierDismissible: false);
          // return 'Your login session has been timed out, please login again';
        }
        else if (respCode == ResponseCode.code_15) {
          Get.back();
          Get.dialog(const ErrorDialog(
              message: 'You logged in on other device', isExpired: true),
              barrierDismissible: false);
          // return 'You logged in on other device';
        }
        else if (respCode == ResponseCode.code_14) {
          Get.back();
          Get.dialog(
              ErrorDialog(message: Error.CHECKSUM_FAILED, isExpired: false),
              barrierDismissible: false);
          // return Error.CHECKSUM_FAILED;
        }
        /*else if (respCode == ResponseCode.code_22) {
            if(apiType == ApiUrlEndpoint.userMBAppLogin){
              return response;
            } else {
              Get.back();
              Get.dialog(ErrorDialog(message: respMessage, isExpired: false), barrierDismissible: false);
            }
          }
          else if (respCode == ResponseCode.code_04) {
            if(apiType == ApiUrlEndpoint.verifyAadharXml){
              return response;
            } else {
              Get.back();
              Get.dialog(ErrorDialog(message: respMessage, isExpired: false), barrierDismissible: false);
            }
          }*/
        else
        if (respMessage.toLowerCase().contains("channel validation failed")) {
          Get.back();
          Get.dialog(
              ErrorDialog(message: Error.CHECKSUM_FAILED, isExpired: false),
              barrierDismissible: false);
          // return Error.CHECKSUM_FAILED;
        } else {
          Get.back();
          Get.dialog(
              ErrorDialog(message: "Unhandled_$respCode", isExpired: false),
              barrierDismissible: false);
          // return 'Unhandled_$respCode';
        }
      }
    } on DioError catch (e) {
      final errorMessage = ApiException.fromDioError(e).toString();
      return errorMessage;
    } catch (e, stackTrace) {
      log("Request handling error: $e StackTrace: $stackTrace");
      Get.back();
      Get.dialog(ErrorDialog(message: response.toString(), isExpired: false),
          barrierDismissible: false);
    }
  }
}
/*  bool isSuccessful(String respCode, String response, String apiType) {

    return respCode == (ResponseCode.code_00) || (apiType == ApiUrlEndpoint.login);

    *//*    || (respCode == (ResponseCode.code_90) && apiType != ApiUrlEndpoint.regdeviceversion)

        || (respCode == (ResponseCode.code_99) && apiType != (ApiUrlEndpoint.checkdeviceversion)*//*
//                || (respCode.equals(_06) && (apiType == CARD_FETCH_DETAILS || apiType == CARD_GET_SESSION));
  }
}*/



/*bool isSuccessful(String respCode, String response, String apiType) {

  return respCode == (ResponseCode.code_00) || apiType == ApiUrlEndpoint.appLogout
      // region Account Creation Max Limit Reached handling
      || (respCode == (ResponseCode.code_90) && apiType != ApiUrlEndpoint.accountCreation)
      // endregion
      || (respCode == (ResponseCode.code_99) &&
          apiType != ApiUrlEndpoint.generateCardME) || (respCode == (ResponseCode.code_01)
      && apiType != ApiUrlEndpoint.addCustBeneAccount)
      || (respCode == (ResponseCode.code_01) && apiType != ApiUrlEndpoint.creCustBene)
      || (apiType == ApiUrlEndpoint.converttoPhysDC && respCode == (ResponseCode.code_03))
      || (apiType == ApiUrlEndpoint.getnewPinSetME && respCode == (ResponseCode.code_73))
      || (apiType == ApiUrlEndpoint.getRechargeOperatorCircle && respCode == (ResponseCode.code_99))
      || (apiType == ApiUrlEndpoint.getMobileOperator && respCode == (ResponseCode.code_99))
      || (apiType == ApiUrlEndpoint.verifyDetailsForgotMPIN && respCode == (ResponseCode.code_06))
      || (respCode == (ResponseCode.code_3) && apiType == ApiUrlEndpoint.postNeftTransfer)
      || (respCode == (ResponseCode.code_3) && apiType == ApiUrlEndpoint.postNeftTxn)
      || (respCode == (ResponseCode.code_3) && apiType == ApiUrlEndpoint.postImpsTransfer)
      || (respCode == (ResponseCode.code_3) && apiType == ApiUrlEndpoint.mobileRecharge)
      || (respCode == (ResponseCode.code_02) && apiType == ApiUrlEndpoint.postImpsTransfer)
      // @PKFeb1620191046AMIST
      || (apiType == ApiUrlEndpoint.generateCardME && respCode != (ResponseCode.code_14)
          && respCode != (ResponseCode.code_15))
      || (apiType == ApiUrlEndpoint.generateCardME && response == ("{}"))
      || (apiType == ApiUrlEndpoint.getProfileDetail && response == ("{}"))
      || (apiType == ApiUrlEndpoint.fetchMandateList && response == ("{}"))
      || (apiType == ApiUrlEndpoint.fetchcomplaintreasons && response == ("null"))
      // @PKFeb1920190144PMIST
      || (respCode == (ResponseCode.code_99) && apiType == ApiUrlEndpoint.holdfundinquiry)
      || (respCode == (ResponseCode.code_02) && apiType == ApiUrlEndpoint.customerBillMap)
      //|| (respCode == (ResponseCode.code_02) && apiType == ADD_FAV_BILL_PAYMENT)
      || (respCode == (ResponseCode.code_02) && apiType == ApiUrlEndpoint.txnAuthorization)
      || (respCode == (ResponseCode.code_4) && apiType == ApiUrlEndpoint.txnAuthorizationTrade)
      || (respCode == (ResponseCode.code_02) && apiType == ApiUrlEndpoint.payRemainder)
      || (respCode == (ResponseCode.code_11) && apiType == ApiUrlEndpoint.fetchCardDetailsv1)
      ||(respCode == (ResponseCode.code_99C0) && apiType == ApiUrlEndpoint.saveCustomerDetails)
      ||(respCode == (ResponseCode.code_99C0) && apiType == ApiUrlEndpoint.customerMiniDetailsNew)
      // ||(respCode == (ResponseCode.code_9911) && apiType == HOLD_AND_TRANSFER)
      ||(respCode == (ResponseCode.code_16) && apiType == ApiUrlEndpoint.getCustData)
      ||(respCode == (ResponseCode.code_17) && apiType == ApiUrlEndpoint.getFetchCustRel)
      || (apiType == ApiUrlEndpoint.favRechargeBill && response == ("{}"))
      || (respCode == (ResponseCode.code_00NA) && apiType == ApiUrlEndpoint.getSMSStatus)
      || (apiType == ApiUrlEndpoint.validateAddress && response == ("{}"))
      || (apiType == ApiUrlEndpoint.upiToken && response == ("{}"))
      || (apiType == ApiUrlEndpoint.userMBAppLogin && response == ("22"))
      || (apiType == ApiUrlEndpoint.verifyAadharXml && response == ("04"))
      || (apiType == ApiUrlEndpoint.userlogintoken && respCode == (ResponseCode.code_01))
      || (apiType == ApiUrlEndpoint.regdeviceversion && respCode == (ResponseCode.code_01))
      || (apiType == ApiUrlEndpoint.faceVerify && (respCode == (ResponseCode.code_06) ||respCode == ("402")))
      || (apiType == ApiUrlEndpoint.aadhaarNameValidate && respCode == (""))
      || (apiType == ApiUrlEndpoint.fetchCustImage && respCode == ResponseCode.code_02)
      || (apiType == ApiUrlEndpoint.txnAuthorization ) || (apiType == ApiUrlEndpoint.getSweepBalEnq);
//                || (respCode.equals(_06) && (apiType == CARD_FETCH_DETAILS || apiType == CARD_GET_SESSION));
}*/
