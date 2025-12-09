import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/profile_model.dart';
import '../../../../data/providers/profile_provider.dart';

class EditProfileController extends GetxController {
  final provider = Get.find<ProfileProvider>();

  late Profile profile;

  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;

  var avatarFile = Rx<File?>(null);
  var avatarPath = ''.obs;

  var saving = false.obs;

  @override
  void onInit() {
    super.onInit();

    profile = Get.arguments;

    name.value = profile.name ?? "";
    phone.value = profile.phone ?? "";
    email.value = profile.email ?? "";
    avatarPath.value = profile.avatar ?? "";
  }

  // PICK IMAGE
  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      avatarFile.value = File(picked.path);
    }
  }

  // SAVE PROFILE
  Future<void> save() async {
    if (name.value.isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }
    if (phone.value.isEmpty) {
      Get.snackbar("Error", "Phone is required");
      return;
    }

    saving(true);

    // Upload avatar if changed
    String? uploadedAvatar;
    if (avatarFile.value != null) {
      uploadedAvatar = await provider.uploadAvatar(avatarFile.value!);
      if (uploadedAvatar == null) {
        Get.snackbar("Error", "Avatar upload failed");
        saving(false);
        return;
      }
    }

    final ok = await provider.updateProfile(
      name: name.value,
      phone: phone.value,
      email: email.value,
      avatar: uploadedAvatar ?? avatarPath.value,
      roleIds: profile.roles?.map((e) => e.id!).toList(),
    );

    saving(false);

    if (ok) {
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } else {
      Get.snackbar("Error", "Failed to update profile");
    }
  }
}
