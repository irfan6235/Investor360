class EnvCUG {
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

  static const RP_KEY_ID = "RP_KEY_ID";
  static const RP_KEY_SECRET = "RP_KEY_SECRET";

  static Map<String, dynamic> cugConfig = {
    ENV: "RELEASE",
    CHANNEL_ID:'dsdjGwLyRqDbsyIGUJIJ',
    APP_DETAILS_PKG:'com.mobile.nsdlpb',
    UPI_DETAILS_PKG:'com.nsdlpb.jiffy',
    HOST:'nsdljiffy.co.in',
    UPI_VMN:'9990011057',
    PUBLIC_KEY_HASH:'sha256/nQVCNXQe0dhJnHDwy+ufMN8LeQBEBOosH/r/tzqHW60=',
    END_POINT:'https://uat-api.nsdl.com/investor360services/api/',
    SITE_KEY:'',
    SECRET_KEY:'',
    app_name:'Jiffy',
    //SSL_FINGERPRINT:'6F 6C 88 22 0C 38 4E 1B 57 D2 06 A7 4C 12 AA 96 F9 77 AF FC 0B DE 93 1A 2D B3 39 46 28 78 22 79,56 90 51 A7 3C A8 B6 E6 81 58 32 56 FB A6 C6 AF E6 DE CB AD 53 09 06 CA 42 20 0D D3 57 0D 2C 6B',
    SSL_FINGERPRINT:'EB:59:0D:C5:19:63:3B:98:CF:FA:A7:68:61:8D:0A:B4:85:AD:84:83:E0:CC:20:65:6A:3A:6D:94:1C:D7:CA:69',
    SSL_EXPIRY:'2023-05-09',
  };
}
