import 'package:get/get.dart';

import '../../../data/repositories/khqr_repository.dart';
import '../../user/cart/controllers/cart_controller.dart';
import '../../user/ordering/controllers/ordering_controller.dart';
import '../../user/profile/controllers/change_password_controller.dart';
import '../../user/profile/controllers/logs_controller.dart';
import '../../user/profile/controllers/profile_controller.dart';
import '../../user/sales/controllers/sales_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<OrderingController>(() => OrderingController(), fenix: true);
    Get.lazyPut<SalesController>(() => SalesController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);

    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(), fenix: true);
    Get.lazyPut<LogsController>(() => LogsController(), fenix: true);
    Get.lazyPut<KhqrRepository>(() => KhqrRepository(), fenix: true);

  }
}
