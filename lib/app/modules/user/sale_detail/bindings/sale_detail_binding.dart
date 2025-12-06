import 'package:get/get.dart';
import '../controllers/sale_detail_controller.dart';

class SaleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleDetailController>(() => SaleDetailController());
  }
}
