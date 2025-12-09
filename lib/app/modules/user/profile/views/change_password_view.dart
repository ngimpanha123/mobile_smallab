import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),

        title: Text(
          "Change Password",
          style: TextStyle(
            fontSize: AppFontSize.headlineMedium,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        actions: [
          Obx(() {
            return TextButton(
              onPressed: controller.saving.value ? null : controller.submit,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: AppFontSize.titleMedium,
                  color: controller.saving.value
                      ? Colors.grey
                      : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          children: [
            _passwordField(
              label: "Old password",
              onChanged: (v) => controller.password.value = v,
            ),
            SizedBox(height: AppSpacing.marginXXL),

            _passwordField(
              label: "New password",
              onChanged: (v) => controller.confirmPassword.value = v,
            ),
            SizedBox(height: AppSpacing.marginXXL),

            _passwordField(
              label: "Confirm password",
              onChanged: (v) => controller.confirmPassword.value = v,
            ),

            SizedBox(height: AppSpacing.marginXL),

            Obx(() {
              return controller.saving.value
                  ? const CircularProgressIndicator()
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required Function(String) onChanged,
  }) {
    final isHidden = true.obs;

    return Obx(() {
      return TextField(
        obscureText: isHidden.value,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: AppFontSize.bodyLarge,
          color: AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            color: AppColors.lightTextSecondary,
          ),
          suffixIcon: InkWell(
            onTap: () => isHidden.value = !isHidden.value,
            child: Icon(
              isHidden.value ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primary,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.3),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      );
    });
  }
}
