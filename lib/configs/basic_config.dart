import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../common/extensions/localication_extend.dart';
import '../models/config_model.dart';
import 'constants.dart';

// variable
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Config config = Config();

// Function
Future initFirebaseRemoteConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    print(await FirebaseRemoteConfig.instance.getString("test"));
  } catch(e) {
    print(e.toString());
  }
}


Future<void> initFirebaseApp(option) async {
  try {
    await Firebase.initializeApp(
      options: option,
    );
    await initFirebaseRemoteConfig();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch(e) {
    print('Error while fetch and activate remote configure: $e');
  }
}

Future setupHive() async {
  Directory documents = await getApplicationDocumentsDirectory();
  Hive.init(documents.path);
  await Hive.openBox(boxAppSettingName);
}
/// setup app language
/// 
/// [currentLanguage] is device language
/// 
/// [supportedLanguage] is config in "constant.dart", each element had to have an ".json" file in "assets/langs/"
Future<LocalizationDelegate> setupAppLanguage() async {
  late final Box boxAppSetting = Hive.box(boxAppSettingName);
  if(boxAppSetting.get("language",) == null) {
    final currentLanguage = (window.locale).toString().split(RegExp('[-_]'))[0];
    print(currentLanguage);
    if(supportedLanguage.contains(currentLanguage)) {
      boxAppSetting.put("language", currentLanguage);
    } else {
      boxAppSetting.put("language", defaultLanguage);
    }
  }
  
  return await LocalizationDelegate.create(
    fallbackLocale: defaultLanguage,
    supportedLocales: supportedLanguage,
    preferences: TranslatePreferences(),
    basePath: 'assets/langs/'
  );
}
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  String shortestSize = data.size.shortestSide < 600 ? 'phone' :'tablet';
  return shortestSize;
}