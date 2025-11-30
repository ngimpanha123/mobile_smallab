import 'package:get/get.dart';
import '../data/controllers/ratio_controller.dart';
import '../data/services/storage_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Already put in main() but binding ensures persistence
    if (!Get.isRegistered<RatioController>()) {
      Get.put(RatioController(), permanent: true);
    }

    // StorageService already created in main, but ensure registered
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }
  }
}
