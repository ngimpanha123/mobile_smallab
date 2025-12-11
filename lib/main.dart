// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'app/data/providers/dashboard_provider.dart';
// import 'app/theme/app_theme.dart';
// import 'app/routes/app_pages.dart';
// import 'app/routes/app_routes.dart';
//
// // Bindings
// import 'app/bindings/global_binding.dart';
//
// // Controllers
// import 'app/data/controllers/ratio_controller.dart';
//
// // Services
// import 'app/data/services/storage_service.dart';
//
// // Providers
// import 'app/data/providers/api_provider.dart';
// import 'app/data/providers/cashier_provider.dart';
// import 'app/data/providers/profile_provider.dart';
// import 'app/data/providers/admin_provider.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Storage
//   await Get.putAsync(() async => await StorageService().init());
//
//   // Register RatioController BEFORE UI builds
//   Get.put(RatioController(), permanent: true);
//
//   // Initialize Providers
//   final api = Get.put(APIProvider());
//   Get.put(CashierProvider(api.dio));
//   Get.put(ProfileProvider(api.dio));
//
//   // Admin Provider
//   Get.put(AdminProvider(api.dio));
//   Get.put(AdminDashboardProvider(api.dio));
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // IMPORTANT: Initialize RatioController for screen scaling
//     RatioController.to.init(context);
//
//     final storage = Get.find<StorageService>();
//
//     return GetMaterialApp(
//       title: "POS Cashier",
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.theme,
//
//       // Register global dependencies for whole app
//       initialBinding: GlobalBinding(),
//
//       getPages: AppPages.pages,
//
//       // App Flow:
//       // If logged in → go Home
//       // If not logged in → Login first
//       initialRoute:
//       storage.isLoggedIn ? Routes.LOGIN : Routes.LOGIN,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_eshop/app/constants/app_color.dart';

import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/bindings/global_binding.dart';

import 'app/data/controllers/ratio_controller.dart';
import 'app/data/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  await Get.putAsync(() => StorageService().init(), permanent: true);

  // Screen ratio controller
  Get.put(RatioController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MUST run first frame to calculate scale ratios
    RatioController.to.init(context);

    final storage = Get.find<StorageService>();
    final user = storage.readUser();

    // Determine Start Route
    String initialRoute;

    if (storage.isLoggedIn) {
      if (user != null && user['roles'] != null) {
        final List roles = user['roles'];

        final bool isAdmin =
        roles.any((r) => r['slug'] == 'admin' || r['name'] == 'អ្នកគ្រប់គ្រង');

        initialRoute = isAdmin ? Routes.HOME_ADMIN : Routes.HOME;
      } else {
        initialRoute = Routes.LOGIN;
      }
    } else {
      initialRoute = Routes.LOGIN;
    }

    return GetMaterialApp(
      title: "POS Cashier",
      debugShowCheckedModeBanner: false,

      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,

      // Global bindings (APIProvider, CashierProvider, AdminProvider, etc.)
      initialBinding: GlobalBinding(),

      getPages: AppPages.pages,

      initialRoute: initialRoute,
    );
  }
}
