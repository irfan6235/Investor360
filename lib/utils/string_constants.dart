class KeyConstants {
  static const String mobileKey = "MobileNumber";
  static const String isFingerprintEnabled = "isFingerprintEnabled";
  static const String isLoggedIn = "isLoggedIn";
  static const String sessionId = "sessionId";
  static const String mpin_count = "0";
  static const String pan = "PanNumber";
  static const String mpin = "MPin";
  static const String name = "Name";
}

class StringConstants {
  static const String kCustomFontFamily = 'CustomFontFamily';
  static const String mpinSetupText =
      "Please create a 6 digit\nM-PIN and setup 2FA for\nextra security";
  static const String loginIntitialText =
      "The next step in the system will involve sending an SMS from your phone to verify if your phone number is associated  with the same device";
  static const String loginPanText =
      "PAN (Permanent Account Number) is required for mobile app login to verify user identity and comply with regulatory KYC norms.";
  static const String smsBindingText =
      "Please wait, sending SMS from your device...";
}

class ResponseCode {
  ResponseCode._();
  static const code_00 = "00";
  static const code_01 = "01";
  static const code_02 = "02";
  static const code_3 = "3";
  static const code_4 = "4";
  static const code_06 = "06";
  static const code_09 = "09";
  static const code_00NA = "00NA";
  static const code_99C0 = "99C0";
  static const code_9911 = "9911";
  static const code_99 = "99";
  static const code_90 = "90";
  static const code_07 = "07";
  static const code_16 = "16";
  static const code_17 = "17";
  static const code_91 = "91";
  static const code_11 = "11";
  static const code_22 = "22";
  static const code_02M = "02M";
  static const code_04 = "04";

  /**
   * MBcheckdeviceversionMENsdlAP
   * {"response":"Internal Server Error While Jarvis Database Operation","respcode":"08"}
   */
  static const String code_08 = "08";
  static const String code_12 = "12";
  static const String code_15 = "15";
  static const String code_14 = "14";
  static const String code_73 = "73";
  static const String code_03 = "03";
  static const String code_999 = "999";
}

class Error {
  static final String COMMON_PART_2 =
      "There seems to be a problem with your request. Please retry in some time.";
  static final String RETRY_TEMP = COMMON_PART_2;
  static final String E001 = COMMON_PART_2 + ""; // (E002)";
  static final String E002 = COMMON_PART_2 + " (E099-";
  static final String LONG_INACTIVITY =
      "We are taking you to Login screen, please wait.";
  static final String BEFORE_30_DAYS_CERT_EXP =
      "Hi, there is a new version of this app with enhanced functionalities. Please download the latest version";
  static final String CERT_EXPIRED =
      "Hi, it seems you are using an old version of Jiffy, please download the latest version";
  // @PKDec242018
  // As shared by Pramit, Dec 24, 2018
  // https://mail.google.com/mail/u/0/#inbox/FMfcgxwBTjzqJSLwsWXwRRhxXxqLdMhM
  static final String COMMON_PART_1 =
      "Sorry! It seems there was a problem in connection. Please check your network-Wifi/Cellular and retry. If problem persists, please retry in some time. ";
  static final String E009 = COMMON_PART_1 + "(E009)";
  static final String E010 = COMMON_PART_1 + "(E010)";
  static final String E011 = COMMON_PART_2 + "(E011)";
  static final String E012 = COMMON_PART_1 + "(E012)";
  static final String E013 = COMMON_PART_2 + "(E013)";
  static final String E014 = COMMON_PART_1 + "(E014)";
  static final String E015 = COMMON_PART_2 + "(E015)";
  static final String E016 = COMMON_PART_2 + "(E016)";
  static final String _15 =
      "15"; // self assigned this code for Channel Validation Failure
  static final String CHECKSUM_FAILED = "Checksum validation failed";
  static String freezeAccount =
      "Your account verification is still pending. Complete it within 30 days of account opening to avoid account freeze.";
  static String kycError =
      "Mobile Number entered on Create Profile page doesn't match with your Aadhaar Linked Mobile number. Go back to create profile page & use Aadhaar linked mobile no. to open a/c on NSDL Jiffy";
  static String validateNameError =
      "Name in Aadhaar doesn’t match with name in PAN";
}
