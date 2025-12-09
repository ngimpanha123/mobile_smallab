import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightBackground,

        // ❌ REMOVE THIS:
        // centerTitle: true,

        titleSpacing: AppSpacing.paddingM,
        automaticallyImplyLeading: false,

        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: AppFontSize.headlineLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              size: AppWidgetSize.iconMedium,
              color: AppColors.primary,
            ),
            onPressed: () => _openSettingsSheet(),
          ),
          SizedBox(width: AppSpacing.paddingM),
        ],
      ),


      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(child: Text("មិនមានទិន្នន័យអ្នកប្រើប្រាស់"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.marginMedium),

              // =============== AVATAR ===============
              CircleAvatar(
                radius: AppWidgetSize.imageMedium,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(
                  AppConfig.getImageUrl(profile.avatar),
                ),
              ),

              SizedBox(height: AppSpacing.marginSM),

              // =============== NAME ===============
              Text(
                profile.name ?? "",
                style: TextStyle(
                  fontSize: AppFontSize.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.marginXS),

              // =============== ROLE ===============
              Text(
                _defaultRole(profile),
                style: TextStyle(
                  fontSize: AppFontSize.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),

              SizedBox(height: AppSpacing.marginXL),

              // =============== INFO CARD ===============
              _buildInfoCard(profile),
              SizedBox(height: AppSpacing.marginMedium),

              // =============== ROLES CARD ===============
              _buildRoleCard(profile),
              SizedBox(height: AppSpacing.marginXL),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // INFO CARD (Phone, Email, Join Date)
  // ---------------------------------------------------------------------------
  Widget _buildInfoCard(Profile p) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.paddingM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.phone, p.phone ?? "-"),
          _divider(),
          _infoRow(Icons.email, p.email ?? "-"),
          _divider(),
          _infoRow(Icons.calendar_today, _formatJoinDate(p)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: AppWidgetSize.iconMedium, color: AppColors.primary),
        SizedBox(width: AppSpacing.marginMedium),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppFontSize.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.marginSM),
      child: Divider(color: Colors.grey.shade300),
    );
  }

  // ---------------------------------------------------------------------------
  // ROLE CARD
  // ---------------------------------------------------------------------------
  Widget _buildRoleCard(Profile p) {
    final role = _defaultRole(p); // "Admin" or "Cashier"

    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.paddingM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          // ADMIN ROLE
          _roleRow(
            title: "Administrators",
            icon: Icons.star,
            active: role == "Admin",
            activeColor: Colors.red,        // Admin color 🔥
          ),

          SizedBox(height: AppSpacing.marginSmall),

          // USER ROLE
          _roleRow(
            title: "User",
            icon: Icons.person_outline,
            active: role == "អ្នកគិតប្រាក់",
            activeColor: Colors.blue,       // User color 🔵
          ),
        ],
      ),
    );
  }

  Widget _roleRow({
    required String title,
    required IconData icon,
    required bool active,
    required Color activeColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppWidgetSize.iconMedium,
          color: active ? activeColor : Colors.grey.shade500,
        ),

        SizedBox(width: AppSpacing.marginMedium),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppFontSize.bodyLarge,
              fontWeight: FontWeight.w600,
              color: active ? activeColor : Colors.grey.shade800,
            ),
          ),
        ),

        if (active)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, size: 16, color: activeColor),
                const SizedBox(width: 4),
                Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }



  // ---------------------------------------------------------------------------
  // SETTINGS BOTTOM SHEET
  // ---------------------------------------------------------------------------
  void _openSettingsSheet() {
    final profile = controller.profile.value;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.paddingM,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======== Drag Handle ========
            Center(
              child: Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // ======== BIG TITLE ========
            Text(
              "Settings", // SETTINGS
              style: TextStyle(
                fontSize: AppFontSize.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: AppSpacing.marginSM),

            // ======== PROFILE SETTINGS ========
            _sheetItem(
              Icons.edit_outlined,
              "Edit information",
                  () => Get.toNamed(Routes.EDIT_PROFILE, arguments: profile),
            ),

            _sheetItem(
              Icons.lock_outline,
              "Change Password",
                  () => Get.toNamed(Routes.CHANGE_PASSWORD, arguments: profile),
            ),

            _sheetItem(
              Icons.history,
              "Activity History",
                  () => Get.toNamed(Routes.LOGS),
            ),

            SizedBox(height: AppSpacing.marginXS),

            const Divider(height: 1),

            // ======== LOGOUT SECTION ========
            _sheetItem(
              Icons.logout,
              "Leave",
                  () async {
                final storage = Get.find<StorageService>();
                await storage.clearSession();
                Get.offAllNamed(Routes.LOGIN);
              },
              isDestructive: true,
            ),

            SizedBox(height: AppSpacing.marginXS),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.25),
    );
  }

  Widget _sheetItem(
      IconData icon,
      String label,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.paddingM,
          horizontal: 4,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppWidgetSize.iconLarge,
              color: isDestructive ? Colors.red : AppColors.primary,
            ),

            SizedBox(width: AppSpacing.marginMedium),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.titleSmall,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? Colors.red : AppColors.primary,
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDestructive
                    ? Colors.red
                    : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  String _defaultRole(Profile p) {
    if (p.roles == null || p.roles!.isEmpty) {
      print("ROLE: Unknown");   // 🔍 print to console
      return "Unknown";
    }

    final def = p.roles!.firstWhere(
          (r) => r.userRoles?["is_default"] == true,
      orElse: () => p.roles!.first,
    );

    final role = def.name ?? "Unknown";

    // 🔥 PRINT ROLE TO CONSOLE
    print("USER ROLE DETECTED: $role");

    return role;
  }

  String _formatJoinDate(Profile p) {
    if (p.createdAt == null) return "-";
    return p.createdAt!.split("T").first;
  }
}
