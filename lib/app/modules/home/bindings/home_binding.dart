import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../ordering/controllers/ordering_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../sales/controllers/sales_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/controllers/change_password_controller.dart';
import '../../profile/controllers/logs_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Main tab controller
    Get.lazyPut<HomeController>(() => HomeController());

    // Tabs
    Get.lazyPut<OrderingController>(() => OrderingController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<SalesController>(() => SalesController());
    Get.lazyPut<ProfileController>(() => ProfileController());

    // Profile-related
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
    Get.lazyPut<LogsController>(() => LogsController());
  }
}
