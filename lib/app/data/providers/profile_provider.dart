import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../models/cashier_log_model.dart';

class ProfileProvider extends GetxService {
  final Dio dio;

  ProfileProvider(this.dio);

  Future<Profile> getProfile() async {
    final res = await dio.get("/api/account/profile");
    return Profile.fromJson(res.data['data']);
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    final res = await dio.post("/api/account/profile/update", data: {
      "name": name,
      "phone": phone,
    });

    return res.statusCode == 200;
  }

  Future<bool> changePassword({
    required String password,
    required String confirmPassword,
  }) async {
    final res =
    await dio.post("/api/account/profile/update-password", data: {
      "password": password,
      "confirm_password": confirmPassword,
    });

    return res.statusCode == 200;
  }

  Future<CashierLog> getLogs({int page = 1}) async {
    final res = await dio.get("/api/cashier/logs?page=$page");
    return CashierLog.fromJson(res.data);
  }


}
