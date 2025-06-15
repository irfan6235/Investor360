import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:investor360/di/service_locator.dart';
import 'package:investor360/routes/app_pages.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';
import 'package:investor360/utils/common_utils.dart';
import 'package:privacy_screen/privacy_screen.dart';
import 'environment/env.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

String envVar = "UAT"; //"CUG" //"PLAYSTORE" //UAT
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Env.setEnvironment(envVar == "UAT"
      ? Environment.UAT
      : envVar == "CUG"
          ? Environment.CUG
          : Environment.PLAYSTORE);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription? subscription;

  bool isInBackground = false;

  @override
  void initState() {
    super.initState();
    // getConnectivity();
    WidgetsBinding.instance.addObserver(this);
    _secureScreen();
  }

  final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.lato().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: NsdlInvestor360Colors.bottomCardHomeColour2,
      primary: NsdlInvestor360Colors.bottomCardHomeColour2,
      secondary: Colors.amber, // Example secondary color
    ),
    useMaterial3: true,
    // Additional customizations for light theme
    primaryColor: NsdlInvestor360Colors.bottomCardHomeColour2,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: NsdlInvestor360Colors.bottomCardHomeColour2,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
      primary: Colors.green,
      secondary: Colors.teal,
    ),
    useMaterial3: true,
    // Additional customizations for dark theme
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Investor 360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: NsdlInvestor360Colors.bottomCardHomeColour2),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.white,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: Routes.splashScreen.name,
      getPages: AppPages.pages,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
          ),
          child: child!,
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      _secureScreen();
    }
  }

  Future<void> _secureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      await PrivacyScreen.instance.enable(
        iosOptions: const PrivacyIosOptions(
          enablePrivacy: true,
          privacyImageName: "LaunchImage",
          autoLockAfterSeconds: 5,
          lockTrigger: IosLockTrigger.didEnterBackground,
        ),
        androidOptions: const PrivacyAndroidOptions(
          enableSecure: true,
          autoLockAfterSeconds: 5,
        ),
        backgroundColor: Colors.white.withOpacity(0),
        blurEffect: PrivacyBlurEffect.extraLight,
      );
    } else {
      await PrivacyScreen.instance.enable(
        iosOptions: const PrivacyIosOptions(
          enablePrivacy: true,
          privacyImageName: "LaunchImage",
          autoLockAfterSeconds: 5,
          lockTrigger: IosLockTrigger.didEnterBackground,
        ),
        androidOptions: const PrivacyAndroidOptions(
          enableSecure: true,
          autoLockAfterSeconds: 5,
        ),
        backgroundColor: Colors.white.withOpacity(0),
        blurEffect: PrivacyBlurEffect.extraLight,
      );
    }
  }

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> eventList) {
        // Assuming you only care about the latest event
        ConnectivityResult result = eventList.last;
        handleConnectivityChange(result);
      },
    );
  }

  Future<void> handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.wifi &&
        result != ConnectivityResult.mobile) {
      Get.snackbar('Internet Status', 'Internet connection is lost');
    } else {
      try {
        final results = await InternetAddress.lookup('www.google.com');
        if (results.isEmpty || results[0].rawAddress.isEmpty) {
          showSnackBarCustom("Internet Status", "Internet connection is lost",
              Colors.black54, Icons.wifi_off);
        } else {
          showSnackBarCustom("Internet Status", "Internet connection is back",
              Colors.black54, Icons.wifi);
        }
      } on SocketException catch (_) {
        showSnackBarCustom("Internet Status", "Internet connection is lost",
            Colors.black54, Icons.wifi_off);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription!.cancel();
    super.dispose();
  }
}
