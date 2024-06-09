import 'package:file_man/app/features/dashboard/cloud/views/screens/cloud_screen.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/home_screen.dart';
import 'package:file_man/app/features/dashboard/index/views/screens/dashboard_screen.dart';
import 'package:file_man/app/features/login/login.dart';
import 'package:file_man/app/features/splash/views/screens/splash_screen.dart';

import 'package:get/get.dart';

part 'app_routes.dart';

/// contains all configuration pages
class AppPages {
  /// when the app is opened this page will be the first to be shown
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => Login(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => DashboardScreen(),
      bindings: [
        DashboardBinding(),
        HomeBinding(),
        CloudBinding(),
      ],
    ),
  ];
}
