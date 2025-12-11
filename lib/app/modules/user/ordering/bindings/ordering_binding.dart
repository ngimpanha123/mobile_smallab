import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/ordering_controller.dart';

class OrderingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<OrderingController>(() => OrderingController(), fenix: true);

  }
}
