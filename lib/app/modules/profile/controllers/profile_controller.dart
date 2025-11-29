import 'package:get/get.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/providers/profile_provider.dart';

class ProfileController extends GetxController {
  final provider = Get.find<ProfileProvider>();

  var profile = Rxn<Profile>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading(true);
      profile.value = await provider.getProfile();
    } catch (e) {
      print("❌ Profile Load Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void openEditProfile() {
    Get.toNamed("/edit-profile", arguments: profile.value);
  }

  void openChangePassword() {
    Get.toNamed("/change-password");
  }

  void openLogs() {
    Get.toNamed("/logs");
  }
}
