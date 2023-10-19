import 'dart:async';
import 'package:compound/config.dart';
import 'package:compound/core/initializer/image_initializer.dart';
import 'package:compound/core/initializer/initializer.dart';
import 'package:compound/core/managers/dialog_manager.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/shared_components/app-bar/app_bar.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_view.dart';
import 'package:compound/shared_components/drawer/drawer_view.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'locator.dart';
import 'router.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppInitializer.initialize();
  runZoned<Future<void>>(() async {},
      onError: Crashlytics.instance.recordError);
  tz.initializeTimeZones();
  setupLocator();
  AppTheme.instance.initialize();
  await loadImage(AssetImage(AppTheme.instance.brandLogo));
  locator<NavigatorService>().initialize(rootPath);
  locator<SharedPreferencesService>().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  @override
  Widget build(BuildContext context) => _uiViewPort(MaterialApp(
        home: StreamBuilder<bool>(
            stream: _authenticationService.loginStatusChangeStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Scaffold(
                  key: locator<DialogService>().scaffoldKey,
                  resizeToAvoidBottomInset: true,
                  drawer: DrawerView(),
                  appBar: AppBarCustom(),
                  body: _initializeViewPort(),
                  bottomNavigationBar: BottomNavigationView(),
                );
              }
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: _initializeViewPort(),
                bottomNavigationBar: BottomNavigationView(),
              );
            }),
      ));

  _uiViewPort(MaterialApp app) {
    return ScreenUtilInit(
        designSize:
            Size(AppTheme.instance.designWidth, AppTheme.instance.designHeight),
        allowFontScaling: true,
        builder: () => app);
  }

  FutureBuilder<bool> _initializeViewPort() {
    return FutureBuilder<bool>(
        future: Future.delayed(Duration(seconds: 0), () {
          return true;
        }),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return _buildBody(context);
          }
          return Container();
        });
  }

  _buildBody(BuildContext context) {
    return MaterialApp(
      title: Config.brandName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      theme: ThemeData(
        secondaryHeaderColor: AppTheme.instance.primaryLightest,
        toggleableActiveColor: AppTheme.instance.primaryLighter,
        fontFamily: AppTheme.instance.primaryFont,
        primaryColor: AppTheme.instance.primaryLighter,
        canvasColor: AppTheme.instance.primaryLighter,
        dialogBackgroundColor: AppTheme.instance.primaryDarker,
        scaffoldBackgroundColor: AppTheme.instance.primaryLighter,
        accentColor: AppTheme.instance.primaryColorBlue,
        hintColor: AppTheme.instance.primaryLightest,
        inputDecorationTheme: AppTheme.instance.getInputDecorationTheme(),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: AppTheme.instance.primaryFont,
              bodyColor: AppTheme.instance.primaryFontColor,
              displayColor: AppTheme.instance.primaryFontColor,
            ),
      ),
      navigatorKey: locator<NavigatorService>().navigatorKey(),
      onGenerateRoute: locator<NavigatorService>().generatedRoutes(),
      navigatorObservers: [locator<NavigatorService>().routeObserver],
    );
  }
}
