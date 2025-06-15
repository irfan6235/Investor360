import 'dart:convert';

class BaseRequest {
  String? channelId;
  String? deviceId;
  String? deviceOS;
  String? signCS;
  String? data;
  String? sessionId;

  BaseRequest({this.channelId, this.deviceId, this.deviceOS, this.signCS, this.data, this.sessionId});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    deviceId = json['deviceId'];
    deviceOS = json['deviceOS'];
    signCS = json['signCS'];
    data = json['data'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelId'] = this.channelId;
    if (sessionId != null) {
      data['sessionId'] = sessionId;
    }

    data['deviceId'] = this.deviceId;
    data['deviceOS'] = this.deviceOS;
    if (signCS != null) {
      data['signCS'] = signCS;
    }
    data['data'] = this.data;

   // data['sessionId'] = this.sessionId;
    return data;
  }

 /* @override
  String toString() {
    return jsonEncode(toJson());
  }*/
  @override
  String toString() {
    return channelId!.toString() + sessionId!.toString() + deviceId!.toString() + deviceOS!.toString() ;
  }
}



