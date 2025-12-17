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

      // ───────────────── AppBar ─────────────────
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        elevation: .5,
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: AppFontSize.titleLarge,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: _confirmLogout,
          ),
        ],
      ),

      // ───────────────── Body ─────────────────
      body: RefreshIndicator(
        onRefresh: controller.fetchProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            children: [
              _profileHeader(),
              const SizedBox(height: 16),
              _accountSection(),
              const SizedBox(height: 16),
              _activityLogs(),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PROFILE HEADER (MODERN ADMIN STYLE)
  // =====================================================
  Widget _profileHeader() {
    return Obx(() {
      final profile = controller.userProfile.value;

      return Card(
        elevation: 1.2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppWidgetSize.imageSmall,
                backgroundColor: AppColors.primary.withOpacity(.1),
                backgroundImage:
                (profile?.avatar != null && profile!.avatar!.isNotEmpty)
                    ? NetworkImage(
                  AppConfig.getImageUrl(profile.avatar!),
                )
                    : null,
                child: (profile?.avatar == null ||
                    profile!.avatar!.isEmpty)
                    ? const Icon(Icons.person,
                    size: 36, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? "-",
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.email ?? "",
                      style: TextStyle(
                        fontSize: AppFontSize.bodySmall,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        profile?.defaultRoleName ?? "-",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // =====================================================
  // ACCOUNT SETTINGS SECTION
  // =====================================================
  Widget _accountSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: showEditProfileSheet,
          ),
          const _Divider(),
          _menuItem(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: showChangePasswordSheet,
          ),
          const _Divider(),

          Obx(() {
            final roles = controller.userProfile.value?.roles ?? [];
            final isAdmin = roles.any((e) => e.slug == "admin");

            if (!isAdmin) return const SizedBox();

            return Column(
              children: [
                _menuItem(
                  icon: Icons.switch_account_outlined,
                  title: "Switch Role",
                  onTap: showSwitchRoleSheet,
                ),
                const _Divider(),
              ],
            );
          }),

          _menuItem(
            icon: Icons.dark_mode_outlined,
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
      dense: true,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSize.bodyMedium,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // =====================================================
  // ACTIVITY LOGS
  // =====================================================
  Widget _activityLogs() {
    return Obx(() {
      if (controller.isLoadingLogs.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.logs.isEmpty) {
        return Card(
          elevation: 1,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.paddingL),
            child: Column(
              children: [
                Icon(Icons.history,
                    size: 40, color: AppColors.greyColor),
                const SizedBox(height: 8),
                Text(
                  "No activity logs",
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: AppFontSize.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Card(
        elevation: 1,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.logs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final log = controller.logs[i];

            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor:
                AppColors.primary.withOpacity(.12),
                child: const Icon(Icons.info_outline,
                    color: AppColors.primary),
              ),
              title: Text(
                log.action,
                style: TextStyle(
                  fontSize: AppFontSize.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                log.timestamp.toString(),
                style: TextStyle(
                  fontSize: AppFontSize.labelSmall,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // =====================================================
  // BOTTOM SHEETS (UNCHANGED LOGIC)
  // =====================================================

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
          const SizedBox(height: 12),
          _textField("Phone", phone),
          const SizedBox(height: 12),
          _textField("Email", email),
          const SizedBox(height: 20),
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

  void showChangePasswordSheet() {
    final pass = TextEditingController();
    final confirm = TextEditingController();

    Get.bottomSheet(
      _sheetWrapper(
        title: "Change Password",
        children: [
          _textField("New Password", pass, obscure: true),
          const SizedBox(height: 12),
          _textField("Confirm Password", confirm, obscure: true),
          const SizedBox(height: 20),
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

  void showSwitchRoleSheet() {
    final roles = controller.userProfile.value?.roles ?? [];

    Get.bottomSheet(
      _sheetWrapper(
        title: "Switch Role",
        children: roles
            .map(
              (role) => ListTile(
            title: Text(role.name.toString()),
            subtitle: Text("Slug: ${role.slug}"),
            leading:
            const Icon(Icons.account_box_outlined),
            onTap: () => controller.switchRole(role.id!),
          ),
        )
            .toList(),
      ),
    );
  }

  // =====================================================
  // HELPERS
  // =====================================================

  Widget _sheetWrapper({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSize.headlineSmall,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _textField(
      String label,
      TextEditingController ctrl, {
        bool obscure = false,
      }) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _submitButton(VoidCallback onPressed) {
    return ElevatedButton(
      style:
      ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: onPressed,
      child: const Text(
        "Save",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // =====================================================
  // LOGOUT (SNACKBAR CONFIRMATION)
  // =====================================================
  void _confirmLogout() {
    Get.snackbar(
      "Logout",
      "Are you sure you want to logout?",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      margin: const EdgeInsets.all(16),
      icon:
      const Icon(Icons.logout, color: AppColors.error),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          controller.logout();
        },
        child: const Text(
          "LOGOUT",
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      duration: const Duration(seconds: 5),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}
