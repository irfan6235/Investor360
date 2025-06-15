import 'package:investor360/modules/services_transact/model/addNsdlBeneficiaryRequest.dart';
import 'package:investor360/modules/services_transact/model/deleteNonNsdlBeneRequest.dart';
import 'package:investor360/modules/services_transact/model/deleteNsdlBeneficiaryRequest.dart';
import 'package:investor360/modules/services_transact/model/getBeneficiariesRequest.dart';
import 'package:investor360/shared/http/master_provider.dart';
import 'package:investor360/utils/api_url_endpoint.dart';

import '../../login/model/common_request.dart';
import '../../login/model/validateOtp_request.dart';
import '../model/addNonNsdlBeneRequest.dart';

class ServiceTransactRepo {
  MasterProvider masterProvider = MasterProvider();

  //Beneficiaries API
  Future getBeneficiaries(
      GetBeneficiariesRequest getBeneficiariesRequest) async {
    String resourceUrl = ApiUrlEndpoint.getBeneficiaries;
    return masterProvider.post(resourceUrl, getBeneficiariesRequest, false);
  }

  Future addNsdlBeneficiary(AddNsdlBeneficiaryRequest addNsdlBene) async {
    String resourceUrl = ApiUrlEndpoint.addNSDLBeneficiary;
    return masterProvider.post(resourceUrl, addNsdlBene, false);
  }

  Future confirmNsdlBeneficiary(CommonRequest commonRequest) async {
    String resourceUrl = ApiUrlEndpoint.confirmNSDLBeneficiary;
    return masterProvider.post(resourceUrl, commonRequest, false);
  }

  Future cancelNSDLBeneficiary(CommonRequest commonRequest) async {
    String resourceUrl = ApiUrlEndpoint.cancelNSDLBeneficiary;
    return masterProvider.post(resourceUrl, commonRequest, false);
  }

  Future validateOTPAddBeneficiary(
      ValidateOtpRequest validateotp, String called) async {
    if (called == "Add") {
      String resourceUrl = ApiUrlEndpoint.validateOTPAddBeneficiary;
      return masterProvider.post(resourceUrl, validateotp, false);
    } else if (called == "Delete") {
      String resourceUrl = ApiUrlEndpoint.validateOTPDeleteBeneficiary;
      return masterProvider.post(resourceUrl, validateotp, false);
    }
  }

  Future deleteNsdlBeneficiary(
      DeleteNsdlBeneficiaryRequest deleteNsdlBene) async {
    String resourceUrl = ApiUrlEndpoint.deleteNSDLBeneficiary;
    return masterProvider.post(resourceUrl, deleteNsdlBene, false);
  }

  Future deleteNonNsdlBeneficiary(
      DeleteNonNsdlBeneficiaryRequest deleteNonNsdlBene) async {
    String resourceUrl = ApiUrlEndpoint.deleteNonNSDLBeneficiary;
    return masterProvider.post(resourceUrl, deleteNonNsdlBene, false);
  }

  Future addNonNsdlBeneficiary(
      GetNonNSDLBeneficiaryRequest getNonNSDLBeneficiaryRequest) async {
    String resourceUrl = ApiUrlEndpoint.addNonNSDLBeneficiary;
    return masterProvider.post(
        resourceUrl, getNonNSDLBeneficiaryRequest, false);
  }
}
