import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/plan_model.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_subscribe_model.dart';
import 'package:sail/router/application.dart';
import 'package:sail/router/routers.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/http/api/AppSettingsManager.dart';
import 'package:sail/http/api/AppSettings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'model/UserPreference.dart';
import 'model/themeCollection.dart';
import 'package:sail/pages/ErrorScreen.dart';
import 'package:sail/constant/app_urls.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appModel = AppModel();
  var userViewModel = UserModel();
  var userSubscribeModel = UserSubscribeModel();
  var serverModel = ServerModel();
  var planModel = PlanModel();

  await userViewModel.refreshData(); // Add this line
  await ScreenUtil.ensureScreenSize();
  MobileAds.instance.initialize();
  // late AppSettings _appSettings;
  // bool _isLoadingSettings = true;
  final AppSettingsManager appSettingsManager = AppSettingsManager(apiEndpoint: AppUrls.baseUrl);
  // final settings = await appSettingsManager.getSettings();
  // final AppSettings settings = new AppSettings();
  // if (settings != null) {
    runApp(MaterialApp(
        home: FutureBuilder(
        future: appSettingsManager.getSettings(null),
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return LoadingScreen(); // Show loading indicator
      } else if (snapshot.hasError) {
        // return ErrorScreen(error: snapshot.error); // Show error screen
        return MaterialApp( // Wrap ErrorScreen with MaterialApp
          title: AppStrings.appName,
          navigatorKey: Application.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Application.router?.generator,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: ErrorScreen(error: snapshot.error,onRetry: () {
            appSettingsManager.getSettings(null); // Retry fetching settings
          }),
        );
      } else if (snapshot.hasData) {
        final settings = snapshot.data as AppSettings;

        // Use xBaseLink if available, otherwise fallback to apiEndpoint
        var xbase = settings.supportLinks.xBaseLink.isNotEmpty && settings.supportLinks.xBaseLink.length>0
            ? settings.supportLinks.xBaseLink
            : [appSettingsManager.apiEndpoint];
        String url = appSettingsManager.apiEndpoint;
           appSettingsManager.firstURLEnable(xbase).then((result){
             url = result;
          });
        AppUrls.updateBaseUrl(appSettingsManager.ensureUrlScheme(url));
        userSubscribeModel.setAppSettings(settings);
        return MultiProvider(providers: [
          ChangeNotifierProvider<AppModel>.value(value: appModel),
          ChangeNotifierProvider<UserModel>.value(value: userViewModel),
          ChangeNotifierProvider<UserSubscribeModel>.value(
              value: userSubscribeModel),
          ChangeNotifierProvider<ServerModel>.value(value: serverModel),
          ChangeNotifierProvider<ThemeCollection>.value(value: ThemeCollection()),
          ChangeNotifierProvider<UserPreference>.value(value: UserPreference()),
          ChangeNotifierProvider<PlanModel>.value(value: planModel)
        ], child: SailApp());
  } else {
  // return ErrorScreen(error: 'Unknown error'); // Default error
        return MaterialApp( // Wrap ErrorScreen with MaterialApp
          title: AppStrings.appName,
          navigatorKey: Application.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Application.router?.generator,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: ErrorScreen(error: 'Unknown error'),
        );
  }
      },
    ),
    )
    );
  // }else{
  //   // Display an error screen or take appropriate action
  //   runApp(MaterialApp(
  //       home: FutureBuilder(
  //       future: appSettingsManager.getSettings(),
  //       builder: (context, snapshot) {
  //         return MaterialApp( // Wrap ErrorScreen with MaterialApp
  //           title: AppStrings.appName,
  //           navigatorKey: Application.navigatorKey,
  //           debugShowCheckedModeBanner: false,
  //           onGenerateRoute: Application.router?.generator,
  //           localizationsDelegates: const [
  //             AppLocalizations.delegate,
  //             GlobalMaterialLocalizations.delegate,
  //             GlobalCupertinoLocalizations.delegate,
  //             GlobalWidgetsLocalizations.delegate,
  //           ],
  //           home: const ErrorScreen(error: 'Internet error'),
  //         );
  //       }),
  //   ),);
  //   // runApp(ErrorScreen(error: 'Internet error'));
  // }
}
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold( // Made the widget const
      body: Center(
        child: CircularProgressIndicator(), // Or your preferred loading indicator
      ),
    );
  }
}

// class ErrorScreen extends StatelessWidget {
//   final Object? error;
//
//   const ErrorScreen({Key? key, required this.error}) : super(key: key); // Made the widget const
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality( // Wrap with Directionality
//         textDirection: TextDirection.ltr,
//         child: Scaffold(
//       body: Center(
//         child: Text('Error: $error'), // Display the error
//       ),
//     ),);
//   }
// }
class SailApp extends StatelessWidget {
  SailApp({Key? key}) : super(key: key) {
    final router = FluroRouter();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // // var userViewModel = Provider.of<UserModel>(context);
    // // var onceuse = userViewModel.getOnceUse();
    // // print("onceuse.toString(): ${onceuse.toString()}");
    // String onceuse = "0";
    // if (onceuse == "1") {
    // } else {

    // }

    AppModel appModel = Provider.of<AppModel>(context);

    services.SystemChrome.setPreferredOrientations([
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.portraitDown
    ]);

    return MaterialApp(
      // <--- /!\ Add the builder
      title: AppStrings.appName,
      navigatorKey: Application.navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router?.generator,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // 美式英语
        Locale('zh', 'CN'), // 简体中文
        Locale('fa_IR', 'PR'), // 简体中文
        //其它Locales
      ],
      // theme: appModel.themeData, //固定主题
      theme: Provider.of<ThemeCollection>(context).getActiveTheme,
    );
  }
}
