// class GetSotFileRequest {
//   String sessionId;
//   String fileId;

//   GetSotFileRequest({
//     required this.sessionId,
//     required this.fileId,
//   });

//   // Factory constructor to create an instance from a JSON map
//   factory GetSotFileRequest.fromJson(Map<String, dynamic> json) {
//     return GetSotFileRequest(
//       sessionId: json['sessionId'],
//       fileId: json['file_id'],
//     );
//   }

//   // Method to convert an instance to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'sessionId': sessionId,
//       'file_id': fileId,
//     };
//   }
// }
import 'dart:convert';
import 'package:investor360/utils/base_request.dart';

class GetSotFileRequest extends BaseRequest {
  String? sessionId;
  String? fileId;

  GetSotFileRequest({
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

  GetSotFileRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
