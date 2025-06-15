import 'dart:convert';
import '../../../utils/base_request.dart';

class GetEspUrlRequest extends BaseRequest {
  String? dpId;
  String? clientId;
  String? espCode;

  GetEspUrlRequest(
      {this.dpId,
      this.clientId,
      this.espCode,
      String? channelId,
      String? deviceId,
      String? deviceOS,
      String? signCS,
      String? sessionId,
      String? data})
      : super(
            channelId: channelId,
            deviceId: deviceId,
            deviceOS: deviceOS,
            signCS: signCS,
            sessionId: sessionId,
            data: data);

  GetEspUrlRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientId = decodedData['clientId'];
      espCode = decodedData['espCode'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': dpId,
      'clientId': clientId,
      'espCode': espCode,
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
          'dpId': dpId,
          'clientId': clientId,
          'espCode': espCode,
        });
  }
}
