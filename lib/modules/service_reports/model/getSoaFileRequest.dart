import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class GetSoaFileRequest extends BaseRequest {
  String? sessionId;
  String? fileId;

  GetSoaFileRequest({
    this.fileId,
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

  GetSoaFileRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      fileId = decodedData['fileId'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'fileId': this.fileId,
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
          'fileId': this.fileId,
        });
  }
}
