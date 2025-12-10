import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../services/storage_service.dart';
import '../../routes/app_routes.dart';

class APIProvider extends GetxService {
  late Dio dio;

  static const String baseUrl = "http://10.0.2.2:3000";

  APIProvider() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach token if exists
          final token = _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          print("➡️ REQUEST: ${options.method} ${options.uri}");
          print("HEADERS: ${options.headers}");
          print("DATA: ${options.data}");

          return handler.next(options);
        },

        onResponse: (response, handler) async {
          print("⬅️ RESPONSE: ${response.statusCode}");
          print("BODY: ${response.data}");

          // -------------------------------
          // TOKEN EXPIRED HANDLING (401)
          // -------------------------------
          if (response.statusCode == 401) {
            print("❌ Token Expired (401) → Logging out…");

            final storage = Get.find<StorageService>();
            await storage.clearSession();

            Get.offAllNamed(Routes.LOGIN);
            return; // Stop further processing
          }

          return handler.next(response);
        },

        onError: (e, handler) async {
          print("❌ API ERROR: ${e.message}");

          // DioError may also contain 401
          if (e.response?.statusCode == 401) {
            print("❌ 401 from DioError → logout…");

            final storage = Get.find<StorageService>();
            await storage.clearSession();
            Get.offAllNamed(Routes.LOGIN);
            return;
          }

          return handler.next(e);
        },
      ),
    );
  }

  // Get stored token
  String? _getToken() {
    try {
      return Get.find<StorageService>().readToken();
    } catch (_) {
      return null;
    }
  }

  // ========================================================
  // WRAPPER HTTP METHODS
  // ========================================================

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? query}) async {
    return await dio.post(path, data: data, queryParameters: query);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? query}) async {
    return await dio.delete(path, queryParameters: query);
  }

  // ========================================================
  // *************** API ENDPOINTS ***************************
  // ========================================================

  // -------- AUTH ----------
  Future<Response> login({
    required String username,
    required String password,
  }) async {
    return await post("/api/account/auth/login", data: {
      "username": username,
      "password": password,
      "platform": "Mobile",
    });
  }

  // -------- ORDERING ----------
  Future<Response> getOrderingProducts() async {
    return await get("/api/cashier/ordering/products");
  }

  Future<Response> sendOrder(List<int> cartProductIds) async {
    return await post("/api/cashier/ordering/order",
        query: {"cart": cartProductIds});
  }

  // -------- SALES ----------
  Future<Response> getSales({int page = 1}) async {
    return await get("/api/cashier/sales", query: {"page": page});
  }

  Future<Response> getSaleView(int saleId) async {
    return await get("/api/cashier/sales/$saleId/view");
  }

  Future<Response> deleteSale(int saleId) async {
    return await delete("/api/cashier/sales/$saleId");
  }

  // -------- LOGS ----------
  Future<Response> getUserLogs({int page = 1}) async {
    return await get("/api/cashier/logs", query: {"page": page});
  }

  // -------- PROFILE ----------
  Future<Response> getProfile() async {
    return await get("/api/account/profile/profile");
  }

  Future<Response> updateProfile({
    required String name,
    required String phone,
  }) async {
    return await post("/api/account/profile/update", data: {
      "name": name,
      "phone": phone,
    });
  }

  Future<Response> updatePassword({
    required String password,
    required String confirmPassword,
  }) async {
    return await post("/api/account/profile/update-password", data: {
      "password": password,
      "confirm_password": confirmPassword,
    });
  }
}
