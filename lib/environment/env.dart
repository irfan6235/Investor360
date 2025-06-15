import 'env_playstore.dart';
import 'env_uat.dart';
import 'env_cug.dart';

enum Environment { UAT, CUG, PLAYSTORE }

enum Gender { M, F, O }

class Env {
  static Map<String, dynamic>? config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.UAT:
        config = EnvUAT.uatConfig;
        break;
      case Environment.CUG:
        config = EnvCUG.cugConfig;
        break;
      case Environment.PLAYSTORE:
        config = EnvPlayStore.playStoreConfig;
        break;
    }
  }

  static get ENV {
    return config!['ENV'];
  }

  static get CHANNEL_ID {
    return config!['CHANNEL_ID'];
  }

  static get APP_DETAILS_PKG {
    return config!['APP_DETAILS_PKG'];
  }

  static get UPI_DETAILS_PKG {
    return config!['UPI_DETAILS_PKG'];
  }

  static get HOST {
    return config!['HOST'];
  }

  static get UPI_VMN {
    return config!['UPI_VMN'];
  }

  static get PUBLIC_KEY_HASH {
    return config!['PUBLIC_KEY_HASH'];
  }

  static get END_POINT {
    return config!['END_POINT'];
  }

  static get SITE_KEY {
    return config!['SITE_KEY'];
  }

  static get SECRET_KEY {
    return config!['SECRET_KEY'];
  }

  static get app_name {
    return config!['app_name'];
  }

  static get SSL_FINGERPRINT {
    return config!['SSL_FINGERPRINT'];
  }

  static get SSL_EXPIRY {
    return config!['SSL_EXPIRY'];
  }

  static get API_URL {
    return config!['API_URL'];
  }
}
