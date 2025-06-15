import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:investor360/environment/env.dart';
import 'package:investor360/modules/login/data/login_repo.dart';
//import 'package:MCX/repo/api_repo.dart';
//import 'package:MCX/storage/hive_manager.dart';


final getIt = GetIt.instance;

void setupLocator() {
  String shaFingerprints = "10:89:48:31:FD:81:D0:70:95:75:63:83:1C:81:67:B0:FF:90:DE:B5:CC:DC:F5:60:E5:6E:A0:D3:D4:64:F2:53";
 // String shaFingerprints1 = "03:B3:75:BC:A9:E8:D3:C9:55:68:6B:5D:46:C8:DC:8A:0B:D9:79:69:EB:27:AD:38:BF:B6:2E:4C:42:27:68:92";
  //getIt.registerSingleton<HiveManager>(HiveManager());
  getIt.registerSingletonAsync(() async {
    ByteData bytes = await rootBundle.load('assets/certificate.cer');
   return Dio(BaseOptions(baseUrl: Env.END_POINT))
     ..interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints: [shaFingerprints]))
    ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final SecurityContext sc = SecurityContext();
          sc.setTrustedCertificatesBytes(bytes.buffer.asUint8List());
          final HttpClient client = HttpClient(context: sc);
          return client;
        },
      );
       //uncomment only for development purpose
      // ..interceptors
      //     .addAll([LogInterceptor(request: true, responseBody: true)]);
  });
 // getIt.registerLazySingleton(() => LoginRepo());  //here commented









  // getIt.registerLazySingleton(
  //     () => Dio(BaseOptions(baseUrl: URLConstants.baseURL2))
  //       ..interceptors
  //           .addAll([LogInterceptor(request: true, responseBody: true)]),
  //     instanceName: 'second');
  // getIt.registerLazySingleton(() => ApiRepo(), instanceName: 'second');

// Alternatively you could write it if you don't like global variables
  //GetIt.I.registerSingleton<AppModel>(AppModel());
}

//HiveManager get hiveManager => getIt.get<HiveManager>();
