// class GetSftFileListRequest {
//   String? sessionId;
//   String? dpid;
//   String? clientid;

//   GetSftFileListRequest({this.sessionId, this.dpid, this.clientid});

//   GetSftFileListRequest.fromJson(Map<String, dynamic> json) {
//     sessionId = json['sessionId'];
//     dpid = json['dpid'];
//     clientid = json['clientid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sessionId'] = this.sessionId;
//     data['dpid'] = this.dpid;
//     data['clientid'] = this.clientid;
//     return data;
//   }
// }
import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class GetSftFileListRequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  dynamic clientId;

  GetSftFileListRequest({
    this.dpId,
    this.clientId,
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

  GetSftFileListRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientid'];
      dpId = decodedData['dpid'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientid': this.clientId,
      'dpid': this.dpId,
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
          'clientid': this.clientId,
          'dpid': this.dpId,
        });
  }
}
