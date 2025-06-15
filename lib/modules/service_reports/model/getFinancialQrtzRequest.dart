import 'dart:convert';

import '../../../utils/base_request.dart';

class GetFinancialqrtzRequest extends BaseRequest {
  String? sessionId;
  String? pan;

  GetFinancialqrtzRequest({
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
            data: data);

  GetFinancialqrtzRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      pan = decodedData['pan'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'pan': this.pan,
    });
    return data;
  }

  @override
  String toString() {
    return channelId.toString() +
        sessionId.toString() +
        deviceId.toString() +
        deviceOS.toString() +
        jsonEncode({
          'pan': this.pan,
        });
  }
}
