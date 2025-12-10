import 'package:get/get.dart';
import '../../../../data/repositories/khqr_repository.dart';
import '../controllers/user_khqr_controller.dart';

class KhqrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KhqrRepository>(() => KhqrRepository(), fenix: true);
    Get.lazyPut<KhqrController>(() => KhqrController());
  }
}
