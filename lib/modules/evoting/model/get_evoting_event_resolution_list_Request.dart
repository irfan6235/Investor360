import 'dart:convert';
import '../../../utils/base_request.dart';

class GetEvotingEventResolutionListRequest extends BaseRequest {
  String? dpId;
  String? clientId;
  String? evenId;

  GetEvotingEventResolutionListRequest(
      {this.dpId,
      this.clientId,
      this.evenId,
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

  GetEvotingEventResolutionListRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientId = decodedData['clientId'];
      evenId = decodedData['evenId'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': dpId,
      'clientId': clientId,
      'evenId': evenId,
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
          'evenId': evenId,
        });
  }
}
