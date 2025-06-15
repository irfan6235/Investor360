import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class EcasDetailRequest extends BaseRequest {
  String? sessionId;
  String? dpId;
  String? clientid;
  String? month;
  String? pan;
  String? year;
  EcasDetailRequest({
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

  EcasDetailRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      dpId = decodedData['dpId'];
      clientid = decodedData['clientid'];
      month = decodedData['month'];
      pan = decodedData['pan'];
      year = decodedData['year'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'dpId': this.dpId,
      'clientId': this.clientid,
      'month': this.month,
      'pan': this.pan,
      'year': this.year,
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
          'month': this.month,
          'pan': this.pan,
          'year': this.year,
        });
  }
}
