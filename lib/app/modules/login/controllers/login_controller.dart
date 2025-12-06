import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final api = Get.find<APIProvider>();
  final storage = Get.find<StorageService>();

  var loading = false.obs;

  Future<void> login({required String password, required String username}) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return;
    }

    try {
      loading(true);

      final res = await api.post(
        "/api/account/auth/login",
        data: {
          "username": username,
          "password": password,
          "platform": "Mobile",
        },
      );

      // SUCCESS LOGIN
      if (res.statusCode == 200 && res.data["token"] != null) {
        String token = res.data["token"];
        List roles = res.data["user"] ?? [];

        await storage.saveToken(token);

        // Extract role slugs
        List<String> roleNames = roles.map((e) => e["slug"].toString()).toList();
        await storage.saveRoles(roleNames);

        // Navigation
        if (roleNames.contains("admin")) {
          Get.offAllNamed(Routes.HOME_ADMIN);   // Admin Dashboard
        } else if (roleNames.contains("cashier")) {
          Get.offAllNamed(Routes.HOME);         // Cashier Dashboard
        } else {
          Get.snackbar("Error", "User has no valid roles!");
        }
      } else {
        Get.snackbar("Login Failed", res.data["message"] ?? "Unknown error");
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      loading(false);
    }
  }

}
