import 'package:investor360/modules/services_others/model/ecasStatusTrackRequest.dart';
import 'package:investor360/modules/services_others/model/getEcasDetailRequest.dart';
import 'package:investor360/modules/services_others/model/subscribeEcasRequest.dart';
import 'package:investor360/modules/services_others/model/updateEcasEmailRequest.dart';
import 'package:investor360/shared/http/master_provider.dart';
import 'package:investor360/utils/api_url_endpoint.dart';

class ServiceOtherRepo {
  MasterProvider masterProvider = MasterProvider();

  Future getEcas(EcasDetailRequest ecasDetailRequest) async {
    String resourceUrl = ApiUrlEndpoint.geteCasDetails;
    return masterProvider.post(resourceUrl, ecasDetailRequest, false);
  }

  Future subscribeEcas(SubcribeEcasRequest subcribeEcasRequest) async {
    String resourceUrl = ApiUrlEndpoint.subscribeEcas;
    return masterProvider.post(resourceUrl, subcribeEcasRequest, false);
  }

  Future updateEcasEmail(UpdateEcasEmailRequest updateEcasEmailRequest) async {
    String resourceUrl = ApiUrlEndpoint.updateEcasEmail;
    return masterProvider.post(resourceUrl, updateEcasEmailRequest, false);
  }

  Future trackEcasStatus(EcasStatusTrackRequest ecasStatusTrackRequest) async {
    String resourceUrl = ApiUrlEndpoint.trackEcasStatus;
    return masterProvider.post(resourceUrl, ecasStatusTrackRequest, false);
  }
}
