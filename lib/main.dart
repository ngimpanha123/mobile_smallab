import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/providers/dashboard_provider.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

// Bindings
import 'app/bindings/global_binding.dart';

// Controllers
import 'app/data/controllers/ratio_controller.dart';

// Services
import 'app/data/services/storage_service.dart';

// Providers
import 'app/data/providers/api_provider.dart';
import 'app/data/providers/cashier_provider.dart';
import 'app/data/providers/profile_provider.dart';
import 'app/data/providers/admin_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage
  await Get.putAsync(() async => await StorageService().init());

  // Register RatioController BEFORE UI builds
  Get.put(RatioController(), permanent: true);

  // Initialize Providers
  final api = Get.put(APIProvider());
  Get.put(CashierProvider(api.dio));
  Get.put(ProfileProvider(api.dio));

  // Admin Provider
  Get.put(AdminProvider(api.dio));
  Get.put(AdminDashboardProvider(api.dio));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Initialize RatioController for screen scaling
    RatioController.to.init(context);

    final storage = Get.find<StorageService>();

    return GetMaterialApp(
      title: "POS Cashier",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      // Register global dependencies for whole app
      initialBinding: GlobalBinding(),

      getPages: AppPages.pages,

      // App Flow:
      // If logged in → go Home
      // If not logged in → Login first
      initialRoute:
      storage.isLoggedIn ? Routes.LOGIN : Routes.LOGIN,
    );
  }
}
