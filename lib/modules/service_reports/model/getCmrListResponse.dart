import 'dart:convert';

class GetCmrListResponseItem {
  int? status;
  String? fileId;
  String? requestedTime;

  GetCmrListResponseItem({this.status, this.fileId, this.requestedTime});

  factory GetCmrListResponseItem.fromJson(Map<String, dynamic> json) {
    return GetCmrListResponseItem(
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

class GetCmrListResponse {
  String? message;
  String? responseCode;
  String? sessionId;
  List<GetCmrListResponseItem>? data;

  GetCmrListResponse(
      {this.message, this.responseCode, this.sessionId, this.data});

  factory GetCmrListResponse.fromJson(Map<String, dynamic> json) {
    return GetCmrListResponse(
      message: json['message'],
      responseCode: json['responseCode'],
      sessionId: json['sessionId'],
      data: (jsonDecode(json['data']) as List)
          .map((item) => GetCmrListResponseItem.fromJson(item))
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
