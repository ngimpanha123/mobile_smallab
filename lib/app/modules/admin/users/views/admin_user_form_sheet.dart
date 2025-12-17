import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../controllers/admin_users_controller.dart';

class AdminUserFormSheet extends GetView<AdminUsersController> {
  final bool isEdit;
  const AdminUserFormSheet({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final title = isEdit ? "Modify user account" : "Create a user account";
    final btn = isEdit ? "Save" : "Create";

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.paddingL,
          right: AppSpacing.paddingL,
          top: AppSpacing.paddingL,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.paddingL,
        ),
        child: Obx(() {
          final roles = controller.roles;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // header row (X ... Save)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSize.titleLarge,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (isEdit) {
                        final u = controller.selectedUser.value;
                        if (u == null) return;
                        controller.updateUser(u.id!);
                      } else {
                        controller.createUser();
                      }
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(btn, style: const TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // avatar
              Stack(
                children: [
                  Obx(() {
                    final img = controller.pickedImage.value;
                    final current = controller.selectedUser.value?.avatar;

                    ImageProvider? provider;

                    if (img != null) {
                      provider = FileImage(img);
                    } else if (current != null && current.isNotEmpty) {
                      provider = NetworkImage(
                        AppConfig.getImageUrl(current),
                      );
                    }

                    return CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.primary,
                      backgroundImage: provider,
                      child: provider == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    );
                  }),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => controller.pickAvatar(),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // form fields (match screenshot)
              TextField(
                controller: controller.nameC,
                decoration: const InputDecoration(labelText: "Name *"),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                value: controller.selectedRoleId.value,
                items: roles
                    .map(
                      (r) => DropdownMenuItem<int>(
                    value: r.id,
                    child: Text(r.name ?? "-"),
                  ),
                )
                    .toList(),
                onChanged: (v) => controller.selectedRoleId.value = v,
                decoration: const InputDecoration(labelText: "Role *"),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller.phoneC,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone *"),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller.emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email *"),
              ),

              if (!isEdit) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: controller.passwordC,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password *"),
                ),
              ],

              const SizedBox(height: 8),
              Text(
                "Primary color: #0c7ea5",
                style: TextStyle(fontSize: AppFontSize.bodySmall, color: AppColors.error),
              ),
            ],
          );
        }),
      ),
    );
  }
}
