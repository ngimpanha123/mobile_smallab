import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';

import '../controllers/admin_users_controller.dart';
import 'admin_user_detail_view.dart';
import 'admin_user_form_sheet.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        elevation: 0.5,
        backgroundColor: AppColors.lightBackground,
        title: Text(
          "Users",
          style: TextStyle(
            fontSize: AppFontSize.titleLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary, size: 24),
            onPressed: () {
              controller.resetForm();
              Get.bottomSheet(
                const AdminUserFormSheet(isEdit: false),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: ListView.builder(
            padding: EdgeInsets.all(AppSpacing.paddingM),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final u = controller.users[index];

              return _UserCard(
                name: u.name ?? "-",
                role: u.primaryRoleName,
                phone: u.phone ?? "-",
                email: u.email ?? "-",
                avatar: u.avatar,
                isActive: u.active,
                onTap: () {
                  Get.to(
                        () => const AdminUserDetailView(),
                    arguments: u.id,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}


class _UserCard extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  final String email;
  final String? avatar;
  final bool isActive;
  final VoidCallback onTap;

  const _UserCard({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: AppSpacing.paddingXS),
        elevation: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingXS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + status
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (avatar != null && avatar!.isNotEmpty)
                        ? NetworkImage(AppConfig.getImageUrl(avatar!))
                        : null,
                    child: (avatar == null || avatar!.isEmpty)
                        ? const Icon(Icons.person, color: AppColors.primary,size: 18)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: AppFontSize.titleLarge,
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            phone,
                            style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.verified_user,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
