import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class UpdateEcasEmailRequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  String? clientid;
  String? email;
  String? pan;
  UpdateEcasEmailRequest({
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

  UpdateEcasEmailRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientid = decodedData['clientid'];
      email = decodedData['email'];
      pan = decodedData['pan'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': this.dpId,
      'clientId': this.clientid,
      'email': this.email,
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
          'dpId': this.dpId,
          'clientId': this.clientid,
          'email': this.email,
          'pan': this.pan,
        });
  }
}
