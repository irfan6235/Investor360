import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class Getcmrlistrequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  dynamic clientId;

  Getcmrlistrequest({
    this.dpId,
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

  Getcmrlistrequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientid'];
      dpId = decodedData['dpid'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientid': this.clientId,
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
          'dpid': this.dpId,
        });
  }
}
