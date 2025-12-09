// profile_provider.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import '../models/profile_model.dart';
import '../models/cashier_log_model.dart';

class ProfileProvider extends GetxService {
  final Dio dio;

  ProfileProvider(this.dio);

  // =============================
  // GET PROFILE
  // =============================
  Future<Profile> getProfile() async {
    final res = await dio.get("/api/account/profile/profile");
    return Profile.fromJson(res.data['data']);
  }

  // =============================
  // UPDATE PROFILE  (FIXED)
  // =============================
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? avatar,
    List<int>? roleIds,
  }) async {
    final payload = {
      "name": name,
      "phone": phone,
      "email": email,
      "avatar": avatar,
      "role_ids": roleIds,
    };

    print("📤 Sending Update Profile Payload:");
    print(payload);

    final res = await dio.put(
      "/api/account/profile/update",
      data: payload,
    );

    return res.statusCode == 200;
  }

  // =============================
  // CHANGE PASSWORD
  // =============================
  Future<bool> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final res = await dio.put(
        "/api/account/profile/update-password",
        data: {
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      return res.statusCode == 200;
    } catch (e) {
      print("❌ Change Password Error: $e");
      return false;
    }
  }

  // =============================
  // GET LOGS  (FIXED ENDPOINT)
  // =============================
  Future<CashierLog> getLogs({int page = 1}) async {
    print("📌 Calling Logs API: /api/account/profile/logs?page=$page");

    final res = await dio.get("/api/account/profile/logs?page=$page");

    return CashierLog.fromJson(res.data);
  }

  // =============================
  // UPLOAD AVATAR
  // =============================
  Future<String?> uploadAvatar(File file) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
      });

      final res = await dio.post(
        "/api/upload",
        data: formData,
      );

      if (res.statusCode == 200) {
        return res.data["path"];
      }
      return null;
    } catch (e) {
      print("❌ Avatar upload error: $e");
      return null;
    }
  }
}
