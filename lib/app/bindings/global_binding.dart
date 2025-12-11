// import 'package:get/get.dart';
// import '../data/controllers/ratio_controller.dart';
// import '../data/services/storage_service.dart';
//
// class GlobalBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Already put in main() but binding ensures persistence
//     if (!Get.isRegistered<RatioController>()) {
//       Get.put(RatioController(), permanent: true);
//     }
//
//     // StorageService already created in main, but ensure registered
//     if (!Get.isRegistered<StorageService>()) {
//       Get.put(StorageService(), permanent: true);
//     }
//   }
// }

import 'package:get/get.dart';

import '../data/providers/api_provider.dart';
import '../data/providers/cashier_provider.dart';
import '../data/providers/profile_provider.dart';
import '../data/providers/admin_provider.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    final api = Get.put(APIProvider(), permanent: true);

    // USER Providers
    Get.put(CashierProvider(api.dio), permanent: true);
    Get.put(ProfileProvider(api.dio), permanent: true);

    // ADMIN Provider
    Get.put(AdminProvider(api.dio), permanent: true);
  }
}
