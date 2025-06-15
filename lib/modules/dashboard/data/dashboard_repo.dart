
import 'package:investor360/modules/login/model/common_request.dart';
import 'package:investor360/utils/base_request.dart';

import '../../../shared/http/master_provider.dart';
import '../../../utils/api_url_endpoint.dart';
import '../model/GetNsdlHoldingDataRequest.dart';

class DashboardRepo{

  MasterProvider masterProvider = MasterProvider();


  Future getNsdlHoldingDataApi(GetNsdlHoldingDataRequest nsdlHoldingDataRequest) async {
    String resourceUrl = ApiUrlEndpoint.getNSDLHoldingData;
    return masterProvider.post(resourceUrl, nsdlHoldingDataRequest, false);
  }

 Future logoutApi(BaseRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.logout;
    return masterProvider.post(resourceUrl, baseRequest , false);
  }

}
