class BaseResponse<T> {
  String? message;
  String? responseCode;
  String? sessionId;
  T? data;

  BaseResponse({this.message, this.responseCode, this.sessionId, this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json, Function(dynamic) create) {
    return BaseResponse<T>(
      message: json['message'],
      responseCode: json['responseCode'],
      sessionId: json['sessionId'],
      data: json['data'] != null ? create(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    data['sessionId'] = this.sessionId;
    data['data'] = this.data != null ? (this.data as dynamic).toJson() : null;
    return data;
  }

  @override
  String toString() {
    return 'BaseResponse{message: $message, responseCode: $responseCode, sessionId: $sessionId, data: $data}';
  }
}


class CommonBaseResponse {
  String? message;
  String? responseCode;
  String? sessionId;
  dynamic data;

  CommonBaseResponse({this.message, this.responseCode, this.sessionId, this.data});

  factory CommonBaseResponse.fromJson(Map<String, dynamic> json) {
    return CommonBaseResponse(
      message: json['message'],
      responseCode: json['responseCode'],
      sessionId: json['sessionId'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    data['sessionId'] = this.sessionId;
    data['data'] = this.data;
    return data;
  }


  @override
  String toString() {
    return 'BaseResponse{message: $message, responseCode: $responseCode, sessionId: $sessionId, data: $data}';
  }
}