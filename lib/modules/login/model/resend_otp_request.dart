import 'package:investor360/utils/base_request.dart';

class ResendOtpRequest extends BaseRequest {
  String? sessionId;
  ResendOtpRequest({
    this.sessionId,
    String? channelId,
    String? deviceId,
    String? deviceOS,
    String? signCS,
  }) : super(
          channelId: channelId,
          deviceId: deviceId,
          deviceOS: deviceOS,
          signCS: signCS,
        );

  @override
  String toString() {
    return channelId!.toString() +
        sessionId!.toString() +
        deviceId!.toString() +
        deviceOS!.toString();
  }
}
