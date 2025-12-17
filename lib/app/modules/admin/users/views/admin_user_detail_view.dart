import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../controllers/admin_users_controller.dart';
import 'admin_user_form_sheet.dart';

class AdminUserDetailView extends GetView<AdminUsersController> {
  const AdminUserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final int userId = Get.arguments as int;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserDetail(userId);
    });

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: Text(
          "User Detail",
          style: TextStyle(
            fontSize: AppFontSize.titleLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              final u = controller.selectedUser.value;
              if (u == null) return;

              controller.fillForm(u);
              Get.bottomSheet(
                const AdminUserFormSheet(isEdit: true),
                isScrollControlled: true,
                backgroundColor: AppColors.lightBackground,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final u = controller.selectedUser.value;
        if (u == null) {
          return const Center(child: Text("No data"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            children: [
              // ───────────── Profile Card ─────────────
              Card(
                elevation: 1.2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingM),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                            (u.avatar != null && u.avatar!.isNotEmpty)
                                ? NetworkImage(
                              AppConfig.getImageUrl(u.avatar!),
                            )
                                : null,
                            child: (u.avatar == null || u.avatar!.isEmpty)
                                ? const Icon(
                              Icons.person,
                              size: 28,
                              color: Colors.grey,
                            )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color:
                                u.active ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              u.name ?? "-",
                              style: TextStyle(
                                fontSize: AppFontSize.bodyLarge,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              u.primaryRoleName,
                              style: TextStyle(
                                fontSize: AppFontSize.bodySmall,
                                color: AppColors.error,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _StatusBadge(isActive: u.active),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ───────────── Info Card ─────────────
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.phone_android,
                      label: "Phone",
                      value: u.phone ?? "-",
                    ),
                    const _Divider(),
                    _InfoTile(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: u.email ?? "-",
                    ),
                    const _Divider(),
                    _InfoTile(
                      icon: Icons.calendar_month,
                      label: "Created At",
                      value: u.createdAt ?? "-",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ───────────── Actions ─────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.toggleStatus(u),
                      icon: Icon(
                        u.active
                            ? Icons.lock_outline
                            : Icons.lock_open,
                      ),
                      label: Text(
                        u.active ? "Deactivate" : "Activate",
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        u.active ? Colors.red : Colors.green,
                        side: BorderSide(
                          color:
                          u.active ? Colors.red : Colors.green,
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        _showDeleteSnackbar(u.id!);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // ───────────── Snackbar Confirmation ─────────────
  void _showDeleteSnackbar(int userId) {
    Get.snackbar(
      "Delete User",
      "This action cannot be undone",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      colorText: Colors.black,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.red,
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.back(); // close snackbar
          controller.deleteUser(userId);
        },
        child: const Text(
          "DELETE",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      duration: const Duration(seconds: 5),
    );
  }
}


class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSize.bodySmall,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFontSize.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(.1)
            : Colors.red.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "ACTIVE" : "INACTIVE",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
