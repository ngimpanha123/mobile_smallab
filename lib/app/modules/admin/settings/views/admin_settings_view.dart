import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../controllers/admin_settings_controller.dart';

class AdminSettingsView extends GetView<AdminSettingsController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _confirmLogout,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: controller.fetchProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileCard(),
              SizedBox(height: AppSpacing.marginLarge),
              _buildAccountMenu(),
              SizedBox(height: AppSpacing.marginLarge),
              _buildActivityLogs(),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PROFILE CARD
  // =====================================================
  Widget _buildProfileCard() {
    return Obx(() {
      final profile = controller.userProfile.value;

      return Container(
        padding: EdgeInsets.all(AppSpacing.paddingXL),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: AppWidgetSize.imageSmall,
              backgroundColor: Colors.white.withOpacity(0.3),
              backgroundImage: (profile?.avatar != null && profile!.avatar!.isNotEmpty)
                  ? NetworkImage(AppConfig.getImageUrl(profile!.avatar))
                  : null,
              child: (profile?.avatar == null || profile!.avatar!.isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            SizedBox(height: AppSpacing.marginMedium),

            Text(
              profile?.name ?? "User Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.marginXS),

            Text(
              profile?.email ?? "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: AppFontSize.bodySmall,
              ),
            ),

            SizedBox(height: AppSpacing.marginSM),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Role: ${profile?.defaultRoleName ?? '-'}",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    });
  }

  // =====================================================
  // ACCOUNT MENU
  // =====================================================
  Widget _buildAccountMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: showEditProfileSheet,
          ),

          const Divider(height: 1),

          _menuItem(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: showChangePasswordSheet,
          ),

          const Divider(height: 1),

          Obx(() {
            final roles = controller.userProfile.value?.roles ?? [];

            // Only Admin should see the switch role button
            final isAdmin = roles.any((e) => e.slug == "admin");

            return isAdmin
                ? Column(
              children: [
                _menuItem(
                  icon: Icons.switch_account,
                  title: "Switch Role",
                  onTap: showSwitchRoleSheet,
                ),
                const Divider(height: 1),
              ],
            )
                : const SizedBox();
          }),

          _menuItem(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: false,
              onChanged: (v) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TextStyle(fontSize: AppFontSize.bodyMedium)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // =====================================================
  // ACTIVITY LOGS
  // =====================================================
  Widget _buildActivityLogs() {
    return Obx(() {
      if (controller.isLoadingLogs.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.logs.isEmpty) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.paddingXL),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: AppColors.greyColor),
              SizedBox(height: 10),
              Text("No activity logs",
                  style: TextStyle(color: AppColors.greyColor)),
            ],
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.logs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final log = controller.logs[i];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(Icons.info_outline, color: AppColors.primary),
              ),
              title: Text(log.action),
              subtitle: Text(
                log.timestamp.toString(),
                style: TextStyle(fontSize: AppFontSize.labelSmall),
              ),
            );
          },
        ),
      );
    });
  }

  // =====================================================
  // BOTTOM SHEETS
  // =====================================================

  // EDIT PROFILE
  void showEditProfileSheet() {
    final profile = controller.userProfile.value;

    final name = TextEditingController(text: profile?.name ?? "");
    final phone = TextEditingController(text: profile?.phone ?? "");
    final email = TextEditingController(text: profile?.email ?? "");

    Get.bottomSheet(
      _sheetWrapper(
        title: "Edit Profile",
        children: [
          _textField("Name", name),
          SizedBox(height: AppSpacing.marginSM),
          _textField("Phone", phone),
          SizedBox(height: AppSpacing.marginSM),
          _textField("Email", email),
          SizedBox(height: AppSpacing.marginSM),
          _submitButton(() async {
            final ok = await controller.updateProfile(
              name: name.text,
              phone: phone.text,
              email: email.text,
            );
            if (ok) Get.back();
          }),
        ],
      ),
    );
  }

  // CHANGE PASSWORD
  void showChangePasswordSheet() {
    final pass = TextEditingController();
    final confirm = TextEditingController();

    Get.bottomSheet(
      _sheetWrapper(
        title: "Change Password",
        children: [
          _textField("New Password", pass, obscure: true),
          SizedBox(height: AppSpacing.marginSM),
          _textField("Confirm Password", confirm, obscure: true),
          SizedBox(height: AppSpacing.marginXL),
          _submitButton(() async {
            final ok = await controller.updatePassword(
              password: pass.text,
              confirmPassword: confirm.text,
            );
            if (ok) Get.back();
          }),
        ],
      ),
    );
  }

  // SWITCH ROLE
  void showSwitchRoleSheet() {
    final roles = controller.userProfile.value?.roles ?? [];

    Get.bottomSheet(
      _sheetWrapper(
        title: "Switch Role",
        children: roles.map((role) {
          return ListTile(
            title: Text(role.name.toString()),
            subtitle: Text("Slug: ${role.slug}"),
            leading: const Icon(Icons.account_box_outlined),
            onTap: () => controller.switchRole(role.id!),
          );
        }).toList(),
      ),
    );
  }

  // Sheet layout wrapper
  Widget _sheetWrapper({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: AppFontSize.headlineSmall,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: AppSpacing.marginXL),
            ...children,
          ],
        ),
      ),
    );
  }

  // Custom textfield
  Widget _textField(String label, TextEditingController ctrl,
      {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label),
    );
  }

  // Submit button
  Widget _submitButton(VoidCallback onPressed) {
    return ElevatedButton(
      style:
      ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: onPressed,
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );
  }

  // =====================================================
  // LOGOUT CONFIRMATION
  // =====================================================
  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
