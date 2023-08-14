import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'configs/basic_config.dart';
import 'configs/style_config.dart';
import 'firebase_options.dart';
import 'models/navigation_observer_model.dart';
import 'providers/app_state.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await initFirebaseApp(DefaultFirebaseOptions.currentPlatform);
  await setupHive();
  final delegate = await setupAppLanguage();
  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          //TODO add more provider here if needed
          ChangeNotifierProvider(create: (_) => AppState())
        ],
        builder: (context, child) {
          context.read<AppState>().initData();
    
          return child!;
        },
        child: const MyApp()
      ),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    config.appObserver = CustomRouteObserver(context: context);
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      // ScreenUtilInit init responsive for app
      child: ScreenUtilInit(
        //default sized for app is iphone 13
        designSize: const Size(390, 844),
        minTextAdapt: getDeviceType() == 'phone' ? false : true, // if phone, will not use min text so it will not be so small on device
        builder: (context,child) {
          return GlobalLoaderOverlay(
            closeOnBackButton: false,
            overlayWidget: const Center(child: CircularProgressIndicator(),),
            overlayColor: Colors.white24,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              navigatorObservers: [config.appObserver],
              //Config localization
              localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  localizationDelegate
                ],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              //config app name
              title: config.appName,
              //config theme
              theme: ThemeData(
                primarySwatch: kPrimaryMaterialColor,
                //TODO this is global theme config here, like font family, ...
              ),
              initialRoute: context.read<AppState>().isLogin ? HomeScreen.id : LoginScreen.id,
              routes: {
                HomeScreen.id : (_) => const HomeScreen(),
                LoginScreen.id : (_) => const LoginScreen(),
              },
            ),
          );
        }
      ),
    );
  }
}
