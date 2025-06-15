import 'dart:convert';
import '../../../utils/base_request.dart';

class LoginRequest extends BaseRequest {
  String? pan;
  String? mobile;

  LoginRequest(
      {this.pan,
      this.mobile,
      String? channelId,
      String? deviceId,
      String? deviceOS,
      String? signCS,
      String? data})
      : super(
            channelId: channelId,
            deviceId: deviceId,
            deviceOS: deviceOS,
            signCS: signCS,
            data: data);

  LoginRequest.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      var decodedData = jsonDecode(json['data']);
      pan = decodedData['pan'];
      mobile = decodedData['mobile'];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['data'] = jsonEncode({
      'pan': this.pan,
      'mobile': this.mobile,
    });
    return data;
  }

  @override
  String toString() {
    return channelId!.toString() + deviceId!.toString() + deviceOS!.toString() +jsonEncode({
      'pan': this.pan,
      'mobile': this.mobile,
    });
  }

//return jsonEncode(toJson());
}
