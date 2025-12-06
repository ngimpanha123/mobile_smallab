import 'package:get/get.dart';
import '../../admin/dashboard/controllers/admin_dashboard_controller.dart';
import '../../admin/sales/controllers/admin_sales_controller.dart';
import '../../admin/settings/controllers/admin_settings_controller.dart';
import '../controllers/home_admin_controller.dart';

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomeController>(() => AdminHomeController());

    // Later you can put your admin module controllers here:
     Get.lazyPut<DashboardController>(() => DashboardController());
     Get.lazyPut<AdminSalesController>(() => AdminSalesController());
    // Get.lazyPut<AdminProductController>(() => AdminProductController());
    // Get.lazyPut<AdminUserController>(() => AdminUserController());
    // ✅ settings tab (this fixes your error)
    Get.lazyPut<AdminSettingsController>(() => AdminSettingsController());
  }
}
