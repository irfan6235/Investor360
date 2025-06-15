import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class CreateSoaFileRequest extends BaseRequest {
  String? sessionId;
  String? fromDate;
  String? toDate;
  String? pan;

  CreateSoaFileRequest({
    this.pan,
    this.fromDate,
    this.toDate,
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

  CreateSoaFileRequest.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      toDate = decodedData['toDate'];
      fromDate = decodedData['fromDate'];
      pan = decodedData['pan'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'toDate': this.toDate,
      'fromDate': this.fromDate,
      'pan': this.pan,
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
          'toDate': this.toDate,
          'fromDate': this.fromDate,
          'pan': this.pan,
        });
  }
}
