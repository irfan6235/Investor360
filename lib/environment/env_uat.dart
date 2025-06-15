class EnvUAT {
  static const ENV = "ENV";

  static const CHANNEL_ID = "CHANNEL_ID";
  static const APP_DETAILS_PKG = "APP_DETAILS_PKG";
  static const UPI_DETAILS_PKG = "UPI_DETAILS_PKG";
  static const HOST = "HOST";
  static const UPI_VMN = "UPI_VMN";
  static const PUBLIC_KEY_HASH = "PUBLIC_KEY_HASH";
  static const END_POINT = "END_POINT";
  static const SITE_KEY = "SITE_KEY";
  static const SECRET_KEY = "SECRET_KEY";
  static const app_name = "app_name";
  static const SSL_FINGERPRINT = "SSL_FINGERPRINT";
  static const SSL_EXPIRY = "SSL_EXPIRY";

  static Map<String, dynamic> uatConfig = {
    ENV: "UAT",
    CHANNEL_ID: 'SdfvdfuPPhDkncOJSFO',
    APP_DETAILS_PKG: 'com.nsdl.investor360',
    HOST: 'uat-api.nsdl.com',
    UPI_VMN: '9990011057',
    PUBLIC_KEY_HASH: 'sha256/tfuzsgyzdjx4AlR4wES32f8NXzKb/gWsxpaSNc6Act0=',
    END_POINT: 'https://uat-api.nsdl.com/',
    SITE_KEY: '6Ldin_oeAAAAAP_sSLowc7ojuMV7k4af9OPqiVMh',
    SECRET_KEY: '6Ldin_oeAAAAAEKjsdZGEO6VadqDTwvfM2djqQfV',
    app_name: 'Investor360',
    //SSL_FINGERPRINT:'C5 9D AC 2A 56 23 29 A3 B6 7E 28 41 BA D3 ED 7E F6 2C 59 22 04 12 C5 FB 00 85 37 0A 23 57 C8 B0,56 90 51 A7 3C A8 B6 E6 81 58 32 56 FB A6 C6 AF E6 DE CB AD 53 09 06 CA 42 20 0D D3 57 0D 2C 6B',
    SSL_FINGERPRINT:
        'A0:3D:F5:1B:5D:37:90:A2:D5:C9:E6:7D:77:F8:03:8F:6C:CA:C1:A4:B2:19:94:A4:E9:B5:3B:6B:C2:E9:D5:A6',
    SSL_EXPIRY: '2024-01-03',
  };
}
