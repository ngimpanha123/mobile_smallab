import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../services/storage_service.dart';

class APIProvider extends GetxService {
  late Dio dio;

  /// Base API URL (change to your backend)
  static const String baseUrl = "http://10.0.2.2:9003";

  /// Constructor
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
        // don't throw DioException for 4xx so we can handle 401 ourselves
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Interceptors for logging & token injection
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          print("➡️ REQUEST: ${options.method} ${options.uri}");
          print("HEADERS: ${options.headers}");
          print("DATA: ${options.data}");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("⬅️ RESPONSE: ${response.statusCode}");
          print("BODY: ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          print("❌ API ERROR: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// Get token from StorageService
  String? _getToken() {
    try {
      final storage = Get.find<StorageService>();
      return storage.readToken();
    } catch (_) {
      return null;
    }
  }

  // ======================================================
  // UNIVERSAL REQUEST METHODS
  // ======================================================

  Future<Response> get(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    return await dio.get(path, queryParameters: query);
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? query,
      }) async {
    return await dio.post(path, data: data, queryParameters: query);
  }

  Future<Response> put(
      String path, {
        dynamic data,
      }) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    return await dio.delete(path, queryParameters: query);
  }

  // ======================================================
  // *************** SPECIFIC API ENDPOINTS ***************
  // ======================================================

  // ---------------------- AUTH --------------------------

  Future<Response> login({
    required String username,
    required String password,
  }) async {
    return await post(
      "/api/account/auth/login",
      data: {
        "username": username,
        "password": password,
        "platform": "Mobile",
      },
    );
  }

  // ----------------- CASHIER / ORDERING -----------------

  Future<Response> getOrderingProducts() async {
    return await get("/api/cashier/ordering/products");
  }

  Future<Response> sendOrder(List<int> cartProductIds) async {
    return await post(
      "/api/cashier/ordering/order",
      query: {"cart": cartProductIds},
    );
  }

  // ---------------------- SALES -------------------------

  Future<Response> getSales({int page = 1}) async {
    return await get("/api/cashier/sales", query: {"page": page});
  }

  Future<Response> getSaleView(int saleId) async {
    return await get("/api/cashier/sales/$saleId/view");
  }

  Future<Response> deleteSale(int saleId) async {
    return await delete("/api/cashier/sales/$saleId");
  }

  // ---------------------- LOGS --------------------------

  Future<Response> getUserLogs({int page = 1}) async {
    return await get("/api/cashier/logs", query: {"page": page});
  }

  // ---------------------- PROFILE -----------------------

  Future<Response> getProfile() async {
    return await get("/api/account/profile");
  }

  Future<Response> updateProfile({
    required String name,
    required String phone,
  }) async {
    return await post(
      "/api/account/profile/update",
      data: {
        "name": name,
        "phone": phone,
      },
    );
  }

  Future<Response> updatePassword({
    required String password,
    required String confirmPassword,
  }) async {
    return await post(
      "/api/account/profile/update-password",
      data: {
        "password": password,
        "confirm_password": confirmPassword,
      },
    );
  }

  // ---------------------- ADMIN (Optional) -----------------------

  Future<Response> getProducts({int? page, int? limit}) async {
    Map<String, dynamic>? query;
    if (page != null || limit != null) {
      query = {};
      if (page != null) query["page"] = page;
      if (limit != null) query["limit"] = limit;
    }
    return await get("/api/admin/products", query: query);
  }

  Future<Response> getProductTypes() async {
    return await get("/api/admin/product-types");
  }

  Future<Response> createProduct({
    required String name,
    required String code,
    required String unitPrice,
    required String typeId,
    String? imageBase64,
  }) async {
    return await post(
      "/api/admin/products",
      data: {
        "name": name,
        "code": code,
        "unit_price": unitPrice,
        "type_id": typeId,
        if (imageBase64 != null) "image": imageBase64,
      },
    );
  }

  Future<Response> updateProduct({
    required int productId,
    required String name,
    required String code,
    required String unitPrice,
    required String typeId,
    String? imageBase64,
  }) async {
    return await post(
      "/api/admin/products/$productId/update",
      data: {
        "name": name,
        "code": code,
        "unit_price": unitPrice,
        "type_id": typeId,
        if (imageBase64 != null) "image": imageBase64,
      },
    );
  }

  Future<Response> deleteProduct({required int productId}) async {
    return await delete("/api/admin/products/$productId");
  }

  Future<Response> deleteProductType({required int typeId}) async {
    return await delete("/api/admin/product-types/$typeId");
  }
}
