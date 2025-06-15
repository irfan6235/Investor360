// class GetSftFileListResponse {
//   int? status;
//   String? message;
//   List<Data>? data;

//   GetSftFileListResponse({this.status, this.message, this.data});

//   GetSftFileListResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null && json['data'] is List) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     } else {
//       throw Exception(
//           "Failed to load data: type '${json['data'].runtimeType}' is not a subtype of type 'List<dynamic>'");
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> response = new Map<String, dynamic>();
//     response['status'] = this.status;
//     response['message'] = this.message;
//     if (this.data != null) {
//       response['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return response;
//   }
// }

// class Data {
//   int? status;
//   String? fileId;
//   String? requestedTime;

//   Data({this.status, this.fileId, this.requestedTime});

//   Data.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     fileId = json['fileId'];
//     requestedTime = json['requestedTime'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['fileId'] = this.fileId;
//     data['requestedTime'] = this.requestedTime;
//     return data;
//   }
// }
import 'dart:convert';

class GetSftFileListResponseItem {
  int? status;
  String? fileId;
  String? requestedTime;

  GetSftFileListResponseItem({this.status, this.fileId, this.requestedTime});

  factory GetSftFileListResponseItem.fromJson(Map<String, dynamic> json) {
    return GetSftFileListResponseItem(
      status: json['status'],
      fileId: json['fileId'],
      requestedTime: json['requestedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'fileId': fileId,
      'requestedTime': requestedTime,
    };
  }
}

class GetSftFileListResponse {
  String? message;
  String? responseCode;
  String? sessionId;
  List<GetSftFileListResponseItem>? data;

  GetSftFileListResponse(
      {this.message, this.responseCode, this.sessionId, this.data});

  factory GetSftFileListResponse.fromJson(Map<String, dynamic> json) {
    return GetSftFileListResponse(
      message: json['message'],
      responseCode: json['responseCode'],
      sessionId: json['sessionId'],
      data: (jsonDecode(json['data']) as List)
          .map((item) => GetSftFileListResponseItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'responseCode': responseCode,
      'sessionId': sessionId,
      'data': jsonEncode(data?.map((item) => item.toJson()).toList()),
    };
  }
}
