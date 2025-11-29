import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_sheet.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text("No profile data"));
        }

        return Column(
          children: [
            const SizedBox(height: 20),

            // PROFILE HEADER
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(profile.avatar ?? ""),
            ),
            const SizedBox(height: 12),
            Text(profile.name ?? "",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(profile.phone ?? "",
                style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),

            // MENU SHEET
            ProfileMenuSheet(
              onEdit: controller.openEditProfile,
              onChangePassword: controller.openChangePassword,
              onLogs: controller.openLogs,
            )
          ],
        );
      }),
    );
  }
}
