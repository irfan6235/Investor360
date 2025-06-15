import 'package:get/get.dart';
import 'package:investor360/coming_soon.dart';
import 'package:investor360/modules/biometric/views/fingerprint_success_screen.dart';
import 'package:investor360/modules/biometric/views/login_mpin_screen.dart';
import 'package:investor360/modules/account/views/accountscreen.dart';
import 'package:investor360/modules/change_mpin/views/change_mpin_screen.dart';
import 'package:investor360/modules/invite/views/invite.dart';
import 'package:investor360/modules/marketscreen.dart';
import 'package:investor360/modules/portfolio/screens/portfolio.dart';
import 'package:investor360/modules/services_others/views/ecas_services.dart';
import 'package:investor360/modules/services_others/views/email_update.dart';
import 'package:investor360/modules/services_others/views/subscribe_ecas.dart';
import 'package:investor360/modules/services_others/views/track_ecas.dart';
import 'package:investor360/modules/services_transact/views/add_beneficiary.dart';
import 'package:investor360/modules/services_transact/views/beneficiary_details.dart';
import 'package:investor360/modules/service_reports/views/ecas.dart';
import 'package:investor360/modules/service_reports/views/statement_account_screen.dart';
import 'package:investor360/modules/service_reports/views/statement_financialTxn_screen.dart';
import 'package:investor360/modules/service_reports/views/statement_transact_screen.dart';
import 'package:investor360/modules/evoting/views/e_voting.dart';
import 'package:investor360/modules/evoting/views/evoting_details.dart';
import 'package:investor360/modules/support/views/supportscreen.dart';

import 'package:investor360/routes/routes.dart';
import 'package:investor360/modules/login/views/login.dart';

import '../modules/biometric/views/enable_fingerprint_screen.dart';
import '../modules/dashboard/views/dashboard_screen.dart';
import '../modules/login/OTP-Screen/otp_screen.dart';
import '../modules/login/views/login_pan_screen.dart';
import '../modules/login/views/mpin_setup.dart';
import '../modules/login/views/mpin_success_screen.dart';
import '../modules/service_reports/views/client_master_report.dart';
import '../modules/service_reports/views/service.dart';
import '../modules/splash/views/splash_screen.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splashScreen.name,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.loginScreen.name,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.loginPanScreen.name,
      page: () => LoginPanScreen(),
    ),
    GetPage(
      name: Routes.loginOTPScreen.name,
      page: () => LoginOtpScreen(),
    ),
    GetPage(
      name: Routes.mpinSetupScreen.name,
      page: () => MpinSetup(),
    ),
    GetPage(
      name: Routes.mpinSuccessScreen.name,
      page: () => MpinSuccessScreen(),
    ),
    GetPage(
      name: Routes.loginMpinScreen.name,
      page: () => LoginMpinScreen(),
    ),
    GetPage(
      name: Routes.enableBiometricScreen.name,
      page: () => EnableFingerPrintScreen(),
    ),
    GetPage(
      name: Routes.fingerprintsuccessScreen.name,
      page: () => FingerprintSuccessScreen(),
    ),
    GetPage(
      name: Routes.dashboardScreen.name,
      transition: Transition.fadeIn,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: Routes.portfolio.name,
      transition: Transition.fadeIn,
      page: () => PortfolioScreen(
        selectedPage: 0,
      ),
    ),
    GetPage(
      name: Routes.account.name,
      transition: Transition.fadeIn,
      page: () => Account(),
    ),
    GetPage(
      name: Routes.market.name,
      transition: Transition.fadeIn,
      page: () => MarketScreen(),
    ),
    GetPage(
      name: Routes.support.name,
      transition: Transition.fadeIn,
      page: () => SupportScreen(),
    ),
    GetPage(
      name: Routes.invite.name,
      transition: Transition.fadeIn,
      page: () => InviteScreen(),
    ),
    GetPage(
      name: Routes.termsofuse.name,
      transition: Transition.fadeIn,
      page: () => const Support(
        name: "Terms of Use",
      ),
    ),
    GetPage(
        name: Routes.changempin.name,
        transition: Transition.fadeIn,
        page: () => ChangeMpinScreen()),
    GetPage(
        name: Routes.services.name,
        transition: Transition.fadeIn,
        page: () => Service(selectedPage: 0)),
    GetPage(
        name: Routes.clientMasterReport.name,
        transition: Transition.fadeIn,
        page: () => const ClientMasterReport()),
    GetPage(
        name: Routes.statementOfTransaction.name,
        transition: Transition.fadeIn,
        page: () => StatementTransactionScreen()),
    GetPage(
        name: Routes.statementOfAccount.name,
        transition: Transition.fadeIn,
        page: () => const StatementAccountScreen()),
    GetPage(
        name: Routes.statementOfFinancialTxn.name,
        transition: Transition.fadeIn,
        page: () => const StatementFinancialTxnScreen()),
    GetPage(
        name: Routes.ecas.name,
        transition: Transition.fadeIn,
        page: () => Ecas()),
    GetPage(
        name: Routes.beneficiary.name,
        transition: Transition.fadeIn,
        page: () => BeneficiaryDetails()),
    GetPage(
        name: Routes.addBeneficiary.name,
        transition: Transition.fadeIn,
        page: () => AddBeneficiary()),
    GetPage(
        name: Routes.eVoting.name,
        transition: Transition.fadeIn,
        page: () => Evoting()),
    GetPage(
        name: Routes.evotingDetail.name,
        transition: Transition.fadeIn,
        page: () => EvotingDetails()),
    GetPage(
        name: Routes.subscribeEcas.name,
        transition: Transition.fadeIn,
        page: () => SubcribeEcasScreen()),
    GetPage(
        name: Routes.trackEcas.name,
        transition: Transition.fadeIn,
        page: () => TrackEcas()),
    GetPage(
        name: Routes.ecasServices.name,
        transition: Transition.fadeIn,
        page: () => EcasServices()),
    GetPage(
        name: Routes.emailUpdate.name,
        transition: Transition.fadeIn,
        page: () => EmailUpdate()),
  ];

  static const String initialRoute = "/splashScreen";
}
