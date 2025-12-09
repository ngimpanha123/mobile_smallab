// lib/app/modules/user/profile/views/edit_profile_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/providers/profile_provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final provider = Get.find<ProfileProvider>();
  final picker = ImagePicker();

  late Profile profile;

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;

  File? avatarFile;

  bool saving = false;
  bool validName = true;
  bool validPhone = true;

  @override
  void initState() {
    super.initState();
    profile = Get.arguments;

    nameCtrl = TextEditingController(text: profile.name);
    phoneCtrl = TextEditingController(text: profile.phone);
    emailCtrl = TextEditingController(text: profile.email);
  }

  // ========================================================
  // PICK AVATAR
  // ========================================================
  Future<void> pickAvatar() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => avatarFile = File(picked.path));
    }
  }

  void validateForm() {
    setState(() {
      validName = nameCtrl.text.trim().length >= 2;
      validPhone = RegExp(r'^[0-9]{8,15}$').hasMatch(phoneCtrl.text.trim());
    });
  }

  bool get isFormValid =>
      validName &&
          validPhone &&
          nameCtrl.text.isNotEmpty &&
          phoneCtrl.text.isNotEmpty &&
          emailCtrl.text.isNotEmpty;

  // ========================================================
  // SAVE PROFILE
  // ========================================================
  Future<void> save() async {
    validateForm();

    if (!isFormValid) {
      Get.snackbar("កំហុស", "សូមបញ្ចូលព័ត៌មានអោយបានត្រឹមត្រូវ");
      return;
    }

    setState(() => saving = true);

    String? avatarToSend;

    // If user changed avatar → upload
    if (avatarFile != null) {
      avatarToSend = await provider.uploadAvatar(avatarFile!);

      if (avatarToSend == null) {
        saving = false;
        Get.snackbar("Error", "Invalid image format");
        setState(() {});
        return;
      }
    } else {
      // Keep old avatar only if backend uploaded file
      if (profile.avatar != null && profile.avatar!.startsWith("upload/")) {
        avatarToSend = profile.avatar;
      }
    }

    final ok = await provider.updateProfile(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      avatar: avatarToSend,
      roleIds: profile.roles?.map((e) => e.id!).toList() ?? [],
    );

    setState(() => saving = false);

    if (ok) {
      Get.back();
      Get.snackbar("ជោគជ័យ", "បានធ្វើបច្ចុប្បន្នភាពព័ត៌មាន");
    } else {
      Get.snackbar("កំហុស", "មិនអាចធ្វើបច្ចុប្បន្នភាពបានទេ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Setting Information",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: saving ? null : save,
            child: saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              "Save",
              style: TextStyle(
                color: isFormValid ? AppColors.primary : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          children: [
            SizedBox(height: 30),

            // ========================================================
            // AVATAR
            // ========================================================
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: avatarFile != null
                      ? FileImage(avatarFile!)
                      : NetworkImage(AppConfig.getImageUrl(profile.avatar))
                  as ImageProvider,
                ),
                GestureDetector(
                  onTap: pickAvatar,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, size: 22),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            // ========================================================
            // NAME
            // ========================================================
            _label("ឈ្មោះ *"),
            _inputField(
              controller: nameCtrl,
              error: validName ? null : "ឈ្មោះត្រូវមានពីរអក្សរឡើងទៅ",
              onChanged: (_) => validateForm(),
            ),
            SizedBox(height: 25),

            // ========================================================
            // PHONE
            // ========================================================
            _label("លេខទូរស័ព្ទ *"),
            _inputField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              error: validPhone ? null : "លេខទូរស័ព្ទត្រឹមត្រូវ",
              onChanged: (_) => validateForm(),
            ),
            SizedBox(height: 25),

            // ========================================================
            // EMAIL
            // ========================================================
            _label("អ៊ីមែល *"),
            _inputField(
              controller: emailCtrl,
              readOnly: true,
              helper:
              "សូមទាក់ទង Admin ប្រសិនបើចង់ប្តូរអ៊ីមែល",
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppFontSize.titleSmall,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    String? error,
    String? helper,
    bool readOnly = false,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        errorText: error,
        helperText: helper,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.3),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
