enum Routes {
  splashScreen,
  loginScreen,
  loginPanScreen,
  loginOTPScreen,
  mpinSetupScreen,
  mpinSuccessScreen,
  loginMpinScreen,
  enableBiometricScreen,
  dashboardScreen,
  fingerprintsuccessScreen,
  chartapp,
  portfolio,
  account,
  market,
  support,
  invite,
  termsofuse,
  changempin,
  services,
  clientMasterReport,
  statementOfTransaction,
  statementOfAccount,
  statementOfFinancialTxn,
  ecas,
  beneficiary,
  addBeneficiary,
  eVoting,
  evotingDetail,
  subscribeEcas,
  trackEcas,
  ecasServices,
  emailUpdate,
}

extension Path on Routes {
  String get name {
    switch (this) {
      case Routes.splashScreen:
        return "/splashScreen";
      case Routes.loginScreen:
        return "/loginScreen";
      case Routes.loginPanScreen:
        return "/loginPanScreen";
      case Routes.loginOTPScreen:
        return "/loginOTPScreen";
      case Routes.mpinSetupScreen:
        return "/mpinSetupScreen";
      case Routes.mpinSuccessScreen:
        return "/mpinSuccessScreen";
      case Routes.loginMpinScreen:
        return "/loginMpinScreen";
      case Routes.enableBiometricScreen:
        return "/enableBiometricScreen";
      case Routes.dashboardScreen:
        return "/dashboardScreen";
      case Routes.fingerprintsuccessScreen:
        return "/fingerprintsuccessScreen";
      case Routes.portfolio:
        return "/portfolio";
      case Routes.account:
        return "/account";
      case Routes.market:
        return "/market";
      case Routes.support:
        return "/support";
      case Routes.invite:
        return "/invite";
      case Routes.termsofuse:
        return "/termsofuse";
      case Routes.changempin:
        return "/changempin";
      case Routes.services:
        return "/services";
      case Routes.clientMasterReport:
        return "/clientMasterReport";
      case Routes.statementOfTransaction:
        return "/statementOfTransaction";
      case Routes.statementOfAccount:
        return "/statementOfAccount";
      case Routes.statementOfFinancialTxn:
        return "/statementOfFinancialTxn";
      case Routes.ecas:
        return "/ecas";
      case Routes.beneficiary:
        return "/beneficiary";
      case Routes.addBeneficiary:
        return "/addBeneficiary";
      case Routes.eVoting:
        return "/eVoting";
      case Routes.evotingDetail:
        return "/evotingDetail";
      case Routes.subscribeEcas:
        return "/subscribeEcas";
      case Routes.trackEcas:
        return "/trackEcas";
      case Routes.ecasServices:
        return "/ecasServices";
      case Routes.emailUpdate:
        return "/emailUpdate";
      default:
        return "/";
    }
  }
}
