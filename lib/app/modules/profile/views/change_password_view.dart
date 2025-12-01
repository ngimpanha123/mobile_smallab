import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change password")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: (v) => controller.password.value = v,
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              onChanged: (v) => controller.confirmPassword.value = v,
            ),
            const SizedBox(height: 30),

            Obx(() {
              return controller.saving.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: controller.submit,
                child: const Text("Update Password"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
