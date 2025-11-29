import 'package:get/get.dart';
import '../../../data/providers/profile_provider.dart';

class ChangePasswordController extends GetxController {
  final provider = Get.find<ProfileProvider>();

  var password = ''.obs;
  var confirmPassword = ''.obs;
  var saving = false.obs;

  Future<void> submit() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      saving(true);
      final ok = await provider.changePassword(
        password: password.value,
        confirmPassword: confirmPassword.value,
      );

      if (ok) {
        Get.snackbar("Success", "Password updated");
        Get.back();
      } else {
        Get.snackbar("Error", "Failed to update password");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      saving(false);
    }
  }
}
