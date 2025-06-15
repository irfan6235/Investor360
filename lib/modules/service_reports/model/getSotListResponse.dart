import 'dart:convert';

class GetSotListResponseItem {
  int? status;
  String? fileId;
  String? requestedTime;

  GetSotListResponseItem({this.status, this.fileId, this.requestedTime});

  factory GetSotListResponseItem.fromJson(Map<String, dynamic> json) {
    return GetSotListResponseItem(
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

class GetSotListResponse {
  String? message;
  String? responseCode;
  String? sessionId;
  List<GetSotListResponseItem>? data;

  GetSotListResponse(
      {this.message, this.responseCode, this.sessionId, this.data});

  factory GetSotListResponse.fromJson(Map<String, dynamic> json) {
    return GetSotListResponse(
      message: json['message'],
      responseCode: json['responseCode'],
      sessionId: json['sessionId'],
      data: (jsonDecode(json['data']) as List)
          .map((item) => GetSotListResponseItem.fromJson(item))
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
