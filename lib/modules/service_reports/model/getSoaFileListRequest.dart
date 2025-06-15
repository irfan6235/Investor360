import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class GetSoaFileListRequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  dynamic clientId;
  String? pan;

  GetSoaFileListRequest({
    this.dpId,
    this.clientId,
    this.pan,
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

  GetSoaFileListRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientid'];
      dpId = decodedData['dpid'];
      pan = decodedData['pan'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientid': this.clientId,
      'dpid': this.dpId,
      'pan': this.pan,
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
          'pan': this.pan,
        });
  }
}
