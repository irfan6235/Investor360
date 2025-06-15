import 'package:investor360/modules/login/model/check_device.dart';
import 'package:investor360/modules/login/model/common_request.dart';
import 'package:investor360/modules/login/model/login_request.dart';
import 'package:investor360/modules/login/model/resend_Otp_request.dart';
import 'package:investor360/modules/login/model/validateOtp_request.dart';
import 'package:investor360/utils/base_request.dart';

import '../../../shared/http/master_provider.dart';
import '../../../utils/api_url_endpoint.dart';

class LoginRepo {
  MasterProvider masterProvider = MasterProvider();

  Future checkDeviceApi(CheckDeviceRequest checkDeviceRequest) async {
    String resourceUrl = ApiUrlEndpoint.checkDevice;
    return masterProvider.post(resourceUrl, checkDeviceRequest, false);
  }

  Future registerDeviceApi(BaseRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.registerDevice;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future loginApi(LoginRequest loginRequest) async {
    String resourceUrl = ApiUrlEndpoint.login;
    return masterProvider.post(resourceUrl, loginRequest, false);
  }

  Future mpinLoginApi(LoginRequest loginRequest) async {
    String resourceUrl = ApiUrlEndpoint.mpinLogin;
    return masterProvider.post(resourceUrl, loginRequest, false);
  }
}

class ValidateOTPAPI {
  MasterProvider masterProvider = MasterProvider();

  Future validateOtpApi(ValidateOtpRequest validateOtprequest) async {
    String resourceUrl = ApiUrlEndpoint.validateOtp;
    return masterProvider.post(resourceUrl, validateOtprequest, false);
  }

  Future resendOtp(ResendOtpRequest resendOtp) async {
    String resourceUrl = ApiUrlEndpoint.resendOtp;
    return masterProvider.post(resourceUrl, resendOtp, false);
  }
}
