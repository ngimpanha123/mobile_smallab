import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/modules/home/bindings/home_binding.dart';

// Services
import 'app/data/services/storage_service.dart';

// Providers
import 'app/data/providers/api_provider.dart';
import 'app/data/providers/cashier_provider.dart';
import 'app/data/providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  await Get.putAsync(() async => await StorageService().init());

  // Initialize API Providers
  final api = Get.put(APIProvider());
  Get.put(CashierProvider(api.dio));
  Get.put(ProfileProvider(api.dio));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();

    return GetMaterialApp(
      title: "POS Cashier",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      getPages: AppPages.pages,
      initialBinding: HomeBinding(),

      // If token exists → Go Home
      // No token → Login
      initialRoute: storage.isLoggedIn ? Routes.HOME : Routes.LOGIN,
    );
  }
}
