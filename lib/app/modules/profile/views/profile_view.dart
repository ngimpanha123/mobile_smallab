import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font_size.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_widget_size.dart';
import '../../../config/app_config.dart';

import '../controllers/profile_controller.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/profile_model.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = controller.profile.value;
          if (profile == null) {
            return const Center(child: Text("No profile data"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.marginLarge),

              // ░░ TOP (Avatar & Name) ░░
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: AppWidgetSize.imageXS,
                      backgroundImage: NetworkImage(
                        AppConfig.getImageUrl(profile.avatar),
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginSmall),

                    Text(
                      profile.name ?? "",
                      style: TextStyle(
                        fontSize: AppFontSize.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginXS),

                    Text(
                      _joinedRole(profile),
                      style: TextStyle(
                        fontSize: AppFontSize.bodyMedium,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.marginLarge),

              // ░░ PROFILE DETAILS ░░
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
                padding: EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.paddingM),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    _infoRow("Phone", profile.phone ?? "-"),
                    _divider(),
                    _infoRow("Email", profile.email ?? "-"),
                    _divider(),
                    _infoRow("Join Date", _formatJoinDate(profile)),
                    _divider(),
                    _infoRow("Default Role", _defaultRole(profile)),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.marginLarge),

              // ░░ ACTION BUTTONS ░░
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
                child: Column(
                  children: [
                    _actionBtn(
                      icon: Icons.edit,
                      label: "កែព័ត៌មានផ្ទាល់ខ្លួន",
                      onTap: controller.openEditProfile,
                    ),
                    SizedBox(height: AppSpacing.marginSmall),

                    _actionBtn(
                      icon: Icons.lock,
                      label: "ប្តូរពាក្យសម្ងាត់",
                      onTap: controller.openChangePassword,
                    ),
                    SizedBox(height: AppSpacing.marginSmall),

                    _actionBtn(
                      icon: Icons.receipt_long,
                      label: "ប្រវត្តិសកម្មភាព",
                      onTap: controller.openLogs,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ░░ LOGOUT BUTTON ░░
              Padding(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                child: GestureDetector(
                  onTap: () async {
                    final storage = Get.find<StorageService>();
                    await storage.clearSession();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.paddingM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.paddingL,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: AppFontSize.titleMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // =============================================================
  // HELPERS
  // =============================================================

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Divider(color: Colors.black12);

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.paddingM),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppWidgetSize.iconMedium,
              color: AppColors.iconColor,
            ),
            SizedBox(width: AppSpacing.marginMedium),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.titleSmall,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: AppWidgetSize.iconSmall,
              color: AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // MODEL HELPERS
  // =============================================================

  /// Convert roles list → "Admin, Cashier"
  String _joinedRole(Profile p) {
    if (p.roles == null || p.roles!.isEmpty) return "Unknown";
    return p.roles!.map((r) => r.name ?? "").join(", ");
  }

  /// Determine default role
  String _defaultRole(Profile p) {
    if (p.roles == null || p.roles!.isEmpty) return "Unknown";

    final def = p.roles!.firstWhere(
          (r) => r.userRoles?["is_default"] == true,
      orElse: () => p.roles!.first,
    );

    return def.name ?? "Unknown";
  }

  /// Format join date: "2025-11-30T15:33:..." → "2025-11-30 15:33"
  String _formatJoinDate(Profile p) {
    if (p.createdAt == null) return "-";

    return p.createdAt!
        .replaceAll("T", " ")
        .replaceAll("Z", "");
  }
}
