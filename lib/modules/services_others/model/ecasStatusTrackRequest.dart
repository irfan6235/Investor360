import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class EcasStatusTrackRequest extends BaseRequest {
  String? sessionId;
  String? email;
  String? month;
  String? pan;
  String? year;
  EcasStatusTrackRequest({
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

  EcasStatusTrackRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      email = decodedData['email'];
      month = decodedData['month'];
      pan = decodedData['pan'];
      year = decodedData['year'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'email': this.email,
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
          'email': this.email,
          'month': this.month,
          'pan': this.pan,
          'year': this.year,
        });
  }
}
