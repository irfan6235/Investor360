import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class CreateCmrFileRequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  dynamic clientId;

  CreateCmrFileRequest({
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

  CreateCmrFileRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      clientId = decodedData['clientId'];
      dpId = decodedData['dpId'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'clientId': this.clientId,
      'dpId': this.dpId,
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
          'clientId': this.clientId,
          'dpId': this.dpId,
        });
  }
}
