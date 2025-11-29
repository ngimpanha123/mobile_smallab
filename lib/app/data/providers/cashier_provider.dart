// lib/app/data/providers/cashier_provider.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/cashier_product_model.dart';
import '../models/cashier_order_model.dart';
import '../models/cashier_sale_model.dart';
import '../models/cashier_sale_view_model.dart';
import '../models/cashier_log_model.dart';
import '../models/profile_model.dart';

class CashierProvider extends GetxService {
  final Dio dio;

  CashierProvider(this.dio);

  // ---------------------------------------------------------------------------
  // 1) GET PRODUCTS
  // ---------------------------------------------------------------------------
  Future<CashierProductResponse> getCashierProducts() async {
    final res = await dio.get("/api/cashier/ordering/products");
    return CashierProductResponse.fromJson(res.data);
  }

  // ---------------------------------------------------------------------------
  // 2) SEND ORDER (UPDATED ✔)
  // Backend expects:
  // {
  //   "cart": "{\"1\":2,\"2\":3}",
  //   "platform": "Mobile"
  // }
  // ---------------------------------------------------------------------------
  Future<OrderData?> sendOrder(Map<String, int> cartMap) async {
    try {
      final String cartJson = jsonEncode(cartMap);

      final body = {
        "cart": cartJson,  // MUST be JSON string
        "platform": "Mobile"
      };

      final res = await dio.post(
        "/api/cashier/ordering/order",
        data: body,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      final data = CashierOrderResponse.fromJson(res.data);
      return data.data;
    } catch (e) {
      print("❌ Order Error: $e");
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 3) GET SALES
  // ---------------------------------------------------------------------------
  Future<CashierSale> getSales({int page = 1}) async {
    final res = await dio.get("/api/cashier/sales?page=$page");
    return CashierSale.fromJson(res.data);
  }

  // ---------------------------------------------------------------------------
  // 4) VIEW SALE DETAIL
  // ---------------------------------------------------------------------------
  Future<CashierSaleView> getSaleView(int saleId) async {
    final res = await dio.get("/api/cashier/sales/$saleId/view");
    return CashierSaleView.fromJson(res.data);
  }

  // ---------------------------------------------------------------------------
  // 5) DELETE SALE
  // ---------------------------------------------------------------------------
  Future<bool> deleteSale(int saleId) async {
    try {
      final res = await dio.delete("/api/cashier/sales/$saleId");
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e) {
      print("❌ Delete Sale Error: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 6) GET USER LOGS
  // ---------------------------------------------------------------------------
  Future<CashierLog> getLogs({int page = 1}) async {
    final res = await dio.get("/api/cashier/logs?page=$page");
    return CashierLog.fromJson(res.data);
  }

  // ---------------------------------------------------------------------------
  // 7) GET PROFILE
  // ---------------------------------------------------------------------------
  Future<Profile> getProfile() async {
    final res = await dio.get("/api/account/profile");
    return Profile.fromJson(res.data['data']);
  }

  // ---------------------------------------------------------------------------
  // 8) UPDATE PROFILE
  // ---------------------------------------------------------------------------
  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final res = await dio.post(
        "/api/account/profile/update",
        data: {
          "name": name,
          "phone": phone,
        },
      );

      return res.statusCode == 200;
    } catch (e) {
      print("❌ Profile Update Error: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 9) UPDATE PASSWORD
  // ---------------------------------------------------------------------------
  Future<bool> updatePassword({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final res = await dio.post(
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
}
