// class CreateSotFileRequest {
//   String sessionId;
//   String fromDate;
//   String toDate;
//   String dpId;
//   String clientId;

//   CreateSotFileRequest({
//     required this.sessionId,
//     required this.fromDate,
//     required this.toDate,
//     required this.dpId,
//     required this.clientId,
//   });

//   // Create an instance from JSON
//   factory CreateSotFileRequest.fromJson(Map<String, dynamic> json) {
//     return CreateSotFileRequest(
//       sessionId: json['sessionId'],
//       fromDate: json['fromDate'],
//       toDate: json['toDate'],
//       dpId: json['dpId'],
//       clientId: json['clientId'],
//     );
//   }

//   // Convert an instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'sessionId': sessionId,
//       'fromDate': fromDate,
//       'toDate': toDate,
//       'dpId': dpId,
//       'clientId': clientId,
//     };
//   }
// }

import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class CreateSotFileRequest extends BaseRequest {
  String? sessionId;
  String? fromDate;
  String? toDate;
  String? dpId;
  dynamic clientId;

  CreateSotFileRequest({
    this.dpId,
    this.clientId,
    this.fromDate,
    this.toDate,
    this.sessionId,
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

  CreateSotFileRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientid'];
      toDate = decodedData['toDate'];
      fromDate = decodedData['fromDate'];
      dpId = decodedData['dpid'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientId': this.clientId,
      'toDate': this.toDate,
      'fromDate': this.fromDate,
      'dpId': this.dpId,
    });
    return data;
  }

  @override
  String toString() {
    return channelId!.toString() +
        sessionId!.toString() +
        deviceId!.toString() +
        deviceOS!.toString() +
        jsonEncode({
          'clientId': this.clientId,
          'toDate': this.toDate,
          'fromDate': this.fromDate,
          'dpId': this.dpId,
        });
  }
}
