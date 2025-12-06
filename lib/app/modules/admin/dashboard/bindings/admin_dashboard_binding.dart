import 'package:get/get.dart';
import '../../../../data/services/dashboard_service.dart';
import '../controllers/admin_dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardService>(() => DashboardService());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
