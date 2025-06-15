import 'dart:convert';
import '../../../utils/base_request.dart';

class GetEspListRequest extends BaseRequest {
  String? dpId;
  String? clientId;

  GetEspListRequest(
      {this.dpId,
      this.clientId,
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

  GetEspListRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientId = decodedData['clientId'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': dpId,
      'clientId': clientId,
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
        });
  }
}
