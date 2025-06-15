

import 'dart:convert';

import 'package:investor360/utils/base_request.dart';

class CheckDeviceRequest extends BaseRequest{
  String? appOS;
  String? appId;
  String? appName;
  String? appReleaseDate;
  String? appVersion;

  CheckDeviceRequest(
      {this.appOS,
        this.appId,
        this.appName,
        this.appReleaseDate,
        this.appVersion, String? channelId,
        String? deviceId,
        String? deviceOS,
        String? signCS,
        String? data}): super(
      channelId: channelId,
      deviceId: deviceId,
      deviceOS: deviceOS,
      signCS: signCS,
      data: data);

  CheckDeviceRequest.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      appOS = decodedData['appOS'];
      appId = decodedData['appId'];
      appName = decodedData['appName'];
      appReleaseDate = decodedData['appReleaseDate'];
      appVersion = decodedData['appVersion'];
    }

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'appOS': this.appOS,
      'appId': this.appId,
      'appName': this.appName,
      'appReleaseDate': this.appReleaseDate,
      'appVersion': this.appVersion,

    });
    return data;
  }


  @override
  String toString() {
    return channelId!.toString() + deviceId!.toString() + deviceOS!.toString() +jsonEncode({
      'appOS': this.appOS,
      'appId': this.appId,
      'appName': this.appName,
      'appReleaseDate': this.appReleaseDate,
      'appVersion': this.appVersion,
    });
  }
}
