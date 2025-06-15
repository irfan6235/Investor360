import 'dart:convert';

import 'package:investor360/utils/base_request.dart';

class GetEcasPdfRequest extends BaseRequest {
  String? casId;
  String? sessionId;

  GetEcasPdfRequest({
    this.casId,
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

  GetEcasPdfRequest.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      casId = decodedData['fileId'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'fileId': this.casId,
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
          'fileId': this.casId,
        });
  }
}
