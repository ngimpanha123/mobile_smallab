import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/providers/profile_provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final provider = Get.find<ProfileProvider>();

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    final Profile profile = Get.arguments;
    nameCtrl = TextEditingController(text: profile.name);
    phoneCtrl = TextEditingController(text: profile.phone);
  }

  Future<void> save() async {
    setState(() => saving = true);

    final ok = await provider.updateProfile(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
    );

    if (ok) {
      Get.snackbar("Success", "Profile updated");
      Get.back();
    } else {
      Get.snackbar("Error", "Failed to update profile");
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("កែប្រែ-Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 30),

            saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: save,
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
