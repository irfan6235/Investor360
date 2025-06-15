import 'dart:convert';

import 'package:investor360/utils/base_request.dart';

class GetEcasRequest extends BaseRequest {
  String? sessionId;
  String? pan;
  String? dpId;
  dynamic? clientId;

  GetEcasRequest({this.pan, this.dpId, this.clientId, this.sessionId, String? channelId,
    String? deviceId,
    String? deviceOS,
    String? signCS,
    String? data}): super(
      channelId: channelId,
      deviceId: deviceId,
      deviceOS: deviceOS,
      signCS: signCS,
      data: data);

  GetEcasRequest.fromJson(Map<String, dynamic> json) {

    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      pan = decodedData['pan'];
      clientId = decodedData['clientid'];
      dpId = decodedData['dpid'];
    //  sessionId = decodedData['sessionId'];
    }

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
    'pan' : this.pan,
    'clientid' : this.clientId,
    'dpid' : this.dpId,
    });
    return data;
  }


  @override
  String toString() {
    return channelId!.toString() + sessionId!.toString() + deviceId!.toString() + deviceOS!.toString() +jsonEncode({
      'pan' : this.pan,
      'clientid' : this.clientId,
      'dpid' : this.dpId,
    }) ;
  }
}
