import 'package:get/get.dart';

import '../controllers/admin_products_controller.dart';
import '../controllers/product_types_controller.dart';

class AdminProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductsController>(
          () => AdminProductsController(),
    );

    // ✅ REGISTER TYPE CONTROLLER HERE
    Get.lazyPut<ProductTypesController>(
          () => ProductTypesController(),
    );
  }
}
