import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/change_password_controller.dart';
import '../controllers/logs_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
    Get.lazyPut<LogsController>(() => LogsController());
  }
}
