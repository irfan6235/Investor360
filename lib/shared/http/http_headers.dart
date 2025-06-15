
//import '../../environment/env.dart';

class GetHTTPHeaders {
  static getHeaders() async {
    Map apiHeaders = <String, dynamic>{};
    String xAuthToken = "";

    // xAuthToken = await getSPString(SharePrefKey.X_AUTH_TOKEN);

    // apiHeaders['X-AUTH-TOKEN'] = Env.API_KEY;
    // apiHeaders['API-KEY'] = Env.API_KEY;

    apiHeaders['content-type']='application/json';

    // (xAuthToken == null && xAuthToken == "") ? Env.API_KEY : xAuthToken;
    return apiHeaders;
  }
}

/*class GetHTTPHeadersLogin {
  static getHeaders() async {
    Map apiHeaders = <String, String>{};

    apiHeaders['X-AUTH-TOKEN'] = Env.API_KEY;
    return apiHeaders;
  }
}*/


class GetHttpHeadersUPIBankVerification{
    static getHeaders() async{

      Map apiHeaders = <String,String>{};

      apiHeaders['Content-Type'] ="application/json";
      apiHeaders['Authorization'] ="Bearer {authToken}";

      return apiHeaders;

    }
}
