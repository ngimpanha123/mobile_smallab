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
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, size: 26, color: AppColors.primary),
            onPressed: () => _openSettingsSheet(context),   // ✅ CALL BOTTOMSHEET HERE
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = controller.profile.value;
          if (profile == null) {
            return const Center(child: Text("មិនមានទិន្នន័យអ្នកប្រើប្រាស់"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12),

                // ---------------- AVATAR ----------------
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage(
                    AppConfig.getImageUrl(profile.avatar),
                  ),
                ),

                SizedBox(height: 12),

                // ---------------- NAME ----------------
                Text(
                  profile.name ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 4),

                // ---------------- ROLE ----------------
                Text(
                  _defaultRole(profile),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),

                SizedBox(height: 20),

                // ---------- USER INFORMATION ----------
                _buildInfoCard(profile),

                SizedBox(height: 18),

                // ---------- ROLES ----------
                _buildRoleCard(profile),

                SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================================
  // MODERN INFO CARD UI
  // ===========================================================================
  Widget _buildInfoCard(Profile p) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
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
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Colors.grey.shade300, thickness: 1),
    );
  }

  // ===========================================================================
  // ROLE CARD
  // ===========================================================================
  Widget _buildRoleCard(Profile p) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _roleItem(Icons.person, "Administrators",
              isSelected: _defaultRole(p) == "Admin"),
          const SizedBox(height: 10),
          _roleItem(Icons.account_circle_outlined, "User",
              isSelected: _defaultRole(p) == "Cashier"),
        ],
      ),
    );
  }

  Widget _roleItem(IconData icon, String title, {bool isSelected = false}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade800),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isSelected)
          const Icon(Icons.check, size: 22, color: Colors.green),
      ],
    );
  }

  // ===========================================================================
  // SETTINGS BOTTOMSHEET
  // ===========================================================================
  void _openSettingsSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 16),

            _sheetItem(
              Icons.edit,
              "Edit Profile",
                  () {
                final p = controller.profile.value;
                if (p == null) {
                  Get.snackbar("Error", "Profile is not loaded yet.");
                  return;
                }
                Get.toNamed(Routes.EDIT_PROFILE, arguments: p);
              },
            ),

            _sheetItem(
              Icons.lock,
              "Change Password",
                  () {
                final p = controller.profile.value;
                if (p == null) {
                  Get.snackbar("Error", "Profile is not loaded yet.");
                  return;
                }
                Get.toNamed(Routes.CHANGE_PASSWORD, arguments: p);
              },
            ),

            _sheetItem(
              Icons.history,
              "My Logs",
                  () {
                final p = controller.profile.value;
                if (p == null) {
                  Get.snackbar("Error", "Profile is not loaded yet.");
                  return;
                }
                Get.toNamed(Routes.LOGIN, arguments: p);
              },
            ),


            const Divider(height: 24),

            _sheetItem(
              Icons.logout,
              "Logout",
                  () async {
                Get.back();
                final storage = Get.find<StorageService>();
                await storage.clearSession();
                Get.offAllNamed(Routes.LOGS);
              },
              isDestructive: true,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
      barrierColor: Colors.black38,
    );
  }

  Widget _sheetItem(IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: isDestructive ? Colors.red: Colors.black87,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================
  String _defaultRole(Profile p) {
    if (p.roles == null || p.roles!.isEmpty) return "Unknown";

    final def = p.roles!.firstWhere(
          (r) => r.userRoles?["is_default"] == true,
      orElse: () => p.roles!.first,
    );

    return def.name ?? "Unknown";
  }

  String _formatJoinDate(Profile p) {
    if (p.createdAt == null) return "-";
    return p.createdAt!.replaceAll("T", " ").replaceAll("Z", "");
  }
}
