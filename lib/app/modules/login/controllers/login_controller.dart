import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final api = Get.find<APIProvider>();
  final storage = Get.find<StorageService>();

  var username = ''.obs;
  var password = ''.obs;
  var loading = false.obs;

  Future<void> login() async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return;
    }

    try {
      loading(true);

      final res = await api.post(
        "/api/account/auth/login",
        data: {
          "username": username.value,
          "password": password.value,
          "platform": "Mobile",
        },
      );

      if (res.statusCode == 200 && res.data["token"] != null) {
        String token = res.data["token"];

        await storage.saveToken(token);
        await storage.saveUser(res.data["user"] ?? {});

        Get.offAllNamed(Routes.HOME);
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
