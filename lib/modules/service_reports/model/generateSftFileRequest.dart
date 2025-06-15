// class GenerateSftFileRequest {
//   String? sessionId;
//   String? monthYear;
//   String? dpId;
//   String? clientId;

//   GenerateSftFileRequest(
//       {this.sessionId, this.monthYear, this.dpId, this.clientId});

//   GenerateSftFileRequest.fromJson(Map<String, dynamic> json) {
//     sessionId = json['sessionId'];
//     monthYear = json['monthYear'];
//     dpId = json['dpId'];
//     clientId = json['clientId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sessionId'] = this.sessionId;
//     data['monthYear'] = this.monthYear;
//     data['dpId'] = this.dpId;
//     data['clientId'] = this.clientId;
//     return data;
//   }
// }
import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:investor360/utils/base_request.dart';

class GenerateSftFileRequest extends BaseRequest {
  String? sessionId;
  String? monthYear;
  String? dpId;
  dynamic clientId;

  GenerateSftFileRequest({
    this.dpId,
    this.clientId,
    this.sessionId,
    this.monthYear,
    String? channelId,
    String? deviceId,
    String? deviceOS,
    String? signCS,
    String? data,
  }) : super(
          channelId: channelId,
          sessionId: sessionId,
          deviceId: deviceId,
          deviceOS: deviceOS,
          signCS: signCS,
          data: data,
        );

  GenerateSftFileRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      monthYear = decodedData['monthYear'];
      clientId = decodedData['clientId'];
      dpId = decodedData['dpId'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'monthYear': this.monthYear,
      'clientId': this.clientId,
      'dpId': this.dpId,
    });
    return data;
  }

  @override
  String toString() {
    return (channelId ?? '') +
        (sessionId ?? '') +
        (deviceId ?? '') +
        (deviceOS ?? '') +
        jsonEncode({
          'monthYear': this.monthYear,
          'clientId': this.clientId,
          'dpId': this.dpId,
        });
  }
}
