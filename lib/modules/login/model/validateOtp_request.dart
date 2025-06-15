import 'dart:convert';

import 'package:investor360/utils/base_request.dart';

class ValidateOtpRequest extends BaseRequest {
  String? sessionId;
  String? otp;
  ValidateOtpRequest(
      {this.sessionId,
      this.otp,
      String? channelId,
      String? deviceId,
      String? deviceOS,
      String? signCS,
      String? data})
      : super(
            channelId: channelId,
            deviceId: deviceId,
            deviceOS: deviceOS,
            signCS: signCS,
            data: data);

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      otp = decodedData['otp'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'otp': this.otp,
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
          'otp': this.otp,
        });
  }
}
