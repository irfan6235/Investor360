import '../../../utils/base_request.dart';

class GetNsdlHoldingDataRequest extends BaseRequest {
  String? sessionId;

  GetNsdlHoldingDataRequest({
    this.sessionId,
    String? channelId,
    String? deviceId,
    String? deviceOS,
    String? signCS,
  }) : super(
          channelId: channelId,
          deviceId: deviceId,
          deviceOS: deviceOS,
          signCS: signCS,
        );

  GetNsdlHoldingDataRequest.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    channelId = json['channelId'];
    deviceId = json['deviceId'];
    deviceOS = json['deviceOS'];
    signCS = json['signCS'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'sessionId': sessionId,
      'channelId': channelId,
      'deviceId': deviceId,
      'deviceOS': deviceOS,
      'signCS': signCS,
    };
    return data;
  }

  @override
  String toString() {
    return channelId.toString() +
        sessionId.toString() +
        deviceId.toString() +
        deviceOS.toString();
  }
}
