// class GetSotListRequest {
//   final String? sessionId;
//   final String? pan;
//   final String? dpid;
//   final String? clientid;

//   GetSotListRequest({this.sessionId, this.pan, this.dpid, this.clientid});

//   factory GetSotListRequest.fromJson(Map<String, dynamic> json) {
//     return GetSotListRequest(
//       sessionId: json['sessionId'],
//       pan: json['pan'],
//       dpid: json['dpid'],
//       clientid: json['clientid'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'sessionId': sessionId,
//       'pan': pan,
//       'dpid': dpid,
//       'clientid': clientid,
//     };
//   }
// }
import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class GetSotListRequest extends BaseRequest {
  String? sessionId;
  String? pan;
  String? dpId;
  dynamic clientId;

  GetSotListRequest({
    this.dpId,
    this.pan,
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

  GetSotListRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientid'];
      pan = decodedData['pan'];
      dpId = decodedData['dpid'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientid': this.clientId,
      'pan': this.pan,
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
          'pan': this.pan,
          'dpid': this.dpId,
        });
  }
}
