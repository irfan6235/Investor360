class ApiUrlEndpoint {
  ApiUrlEndpoint._();

  // Pre login apis
  static const String checkDevice = "investor360services/api/check-device";
  static const String registerDevice = "investor360services/api/register-device";
  static const String mpinLogin = "investor360services/api/mpin-login";
  static const String login = "investor360services/api/login";
  static const String validateOtp = "investor360services/api/validate-otp";
  static const String resendOtp = "investor360services/api/resend-otp";

  //Post login apis
  static const String getNSDLHoldingData = "investor360services/api/get-nsdl-holding-data";
  static const String logout = "investor360services/api/logout";

  //services
  static const String ecas = "investor360services/report/get-cas";
  static const String ecasPdf = "investor360services/report/get-cas-pdf";
  static const String sotList = "investor360services/report/get-sot-list";
  static const String createSot = "investor360services/report/generate-sot";
  static const String getSotFile = "investor360services/report/get-sot-file";

  static const String cmrList = "investor360services/report/get-cmr-list";
  static const String createCmr = "investor360services/report/generate-cmr";
  static const String getCmrFile = "investor360services/report/get-cmr-file";

  static const String getfinancialqrts = "investor360services/report/get-financial-qrts";
  static const String getsftfile = "investor360services/report/get-sft-file";
  static const String generatesftfile = "investor360services/report/generate-sft";
  static const String getSftFileList = "investor360services/report/get-sft-list";

  static const String getSoaFileList = "investor360services/report/get-soa-list";
  static const String getsoafile = "investor360services/report/get-soa-file";
  static const String generatesoafile = "investor360services/report/generate-soa";

  // beneficiary
  static const String getBeneficiaries = "investor360services/api/getBeneficiaries";
  static const String addNSDLBeneficiary = "investor360services/api/addNSDLBeneficiary";
  static const String confirmNSDLBeneficiary = "investor360services/api/confirmNSDLBeneficiary";
  static const String validateOTPAddBeneficiary =
      "investor360services/api/validateOTPAddBeneficiary";
  static const String cancelNSDLBeneficiary = "investor360services/api/cancelNSDLBeneficiary";
  static const String deleteNSDLBeneficiary = "investor360services/api/deleteNSDLBeneficiary";
  static const String validateOTPDeleteBeneficiary =
      "investor360services/api/validateOTPDeleteBeneficiary";

  static const String addNonNSDLBeneficiary = "investor360services/api/addNonNSDLBeneficiary";
  static const String deleteNonNSDLBeneficiary = "investor360services/api/deleteNonNSDLBeneficiary";


  //subscribe eCas
  static const String geteCasDetails = "investor360services/api/get-cas-details";
  static const String subscribeEcas = "investor360services/api/subscribe-cas";

  // eCas services
  static const String updateEcasEmail = "investor360services/api/update-cas-email";
  static const String trackEcasStatus = "investor360services/api/track-cas-status";

  //eVoting
  static const String getEvotingCount = "investor360-evoting/api/get-evoting-count";
  static const String getEvotingEventList = "investor360-evoting/api/get-evoting-event-list";
  static const String getEvotingEventResolutionList = "investor360-evoting/api/get-evoting-event-resolution-list";
  static const String getEspEventList = "investor360-evoting/api/get-esp-event-list";
  static const String getEspUrl = "investor360-evoting/api/get-esp-url";
  static const String getCastVote = "investor360-evoting/api/cast-vote";


}
