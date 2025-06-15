import 'package:investor360/modules/evoting/model/cast_vote-request.dart';
import 'package:investor360/modules/evoting/model/get_esp_list_request.dart';
import 'package:investor360/modules/evoting/model/get_esp_url_request.dart';
import 'package:investor360/modules/evoting/model/get_evoting_event_resolution_list_Request.dart';
import 'package:investor360/shared/http/master_provider.dart';
import 'package:investor360/utils/api_url_endpoint.dart';
import 'package:investor360/utils/base_request.dart';

class EvotingRepo {
  MasterProvider masterProvider = MasterProvider();

  Future getEvotingCount(BaseRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getEvotingCount;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future getEvotingEventList(BaseRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getEvotingEventList;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future getEvotingResolutionList(
      GetEvotingEventResolutionListRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getEvotingEventResolutionList;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future getEspList(GetEspListRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getEspEventList;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future getEspUrl(GetEspUrlRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getEspUrl;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }

  Future castVote(CastVoteRequest baseRequest) async {
    String resourceUrl = ApiUrlEndpoint.getCastVote;
    return masterProvider.post(resourceUrl, baseRequest, false);
  }
}
