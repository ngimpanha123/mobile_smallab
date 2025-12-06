// // lib/app/data/providers/admin_provider.dart
// import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;
//
// class AdminProvider extends GetxService {
//   final Dio dio;
//
//   AdminProvider(this.dio);
//
//   /// GET /api/admin/dashboard
//   Future<Response> getDashboard() async {
//     return await dio.get("/api/admin/dashboard");
//   }
//
//   /// GET /api/admin/dashboard/cashier
//   Future<Response> getTopCashiers() async {
//     return await dio.get("/api/admin/dashboard/cashier");
//   }
//
//   /// GET /api/admin/dashboard/product-type
//   Future<Response> getProductTypeChart({
//     required int week,
//     required int year,
//   }) async {
//     return await dio.get(
//       "/api/admin/dashboard/product-type",
//       queryParameters: {"week": week, "year": year},
//     );
//   }
//
//   /// GET /api/admin/dashboard/data-sale
//   Future<Response> getSaleData({
//     required String sixMonthsAgo,
//   }) async {
//     return await dio.get(
//       "/api/admin/dashboard/data-sale",
//       queryParameters: {"sixMonthAgo": sixMonthsAgo},
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../services/storage_service.dart';
import '../../config/app_config.dart';

class AdminProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  AdminProvider(Dio dio);

  Future<Response> login({
    required String username,
    required String password,
    required String platform,
  }) async {
    try {
      // ✅ Corrected API endpoint
      final response = await _dio.post(
        '/account/auth/login',
        data: {
          'username': username,
          'password': password,
          'platform': platform,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          "Server error: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // ✅ Get Products
  /// Fetch products with optional pagination
  /// Set [limit] to a high number (e.g., 1000) to get all products
  /// Set [page] for pagination (default: 1)
  Future<Response> getProducts({bool getAll = false, int? page, int? limit}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      print('🔑 Token: ${token?.substring(0, 15)}...');

      // Build query parameters
      Map<String, dynamic> queryParams = {};

      if (getAll) {
        // Force backend to return ALL products
        queryParams['page'] = 1;
        queryParams['limit'] = 100000;
      } else {
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      print('🌍 URL: ${_dio.options.baseUrl}/admin/products');
      print('📌 Query: $queryParams');

      final response = await _dio.get(
        '/admin/products',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('📦 Response Status: ${response.statusCode}');
      print('📦 Response Data: ${response.data}');
      print('-------------------------------------------');

      return response;

    } catch (e) {
      print('❌ Products API Error: $e');
      print('-------------------------------------------');
      rethrow;
    }
  }


  // ✅ Get Dashboard Data
  Future<Response> getDashboard({required String today}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/dashboard',
        queryParameters: {'today': today},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Dashboard API Error: $e');
      rethrow;
    }
  }

  // ✅ Get Cashier Data
  Future<Response> getCashierData({required String today}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/dashboard/cashier',
        queryParameters: {'today': today},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Cashier API Error: $e');
      rethrow;
    }
  }

  // ✅ Get Product Type Data
  Future<Response> getProductTypeData({required String thisMonth}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/dashboard/product-type',
        queryParameters: {'thisMonth': thisMonth},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Product Type API Error: $e');
      rethrow;
    }
  }

  // ✅ Get Sales Data
  Future<Response> getSalesData() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/dashboard/data-sale',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Sales Data API Error: $e');
      rethrow;
    }
  }

  // ✅ Get Sales Data by Period (today, week, month, 6months)
  Future<Response> getSalesByPeriod({required String period}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/dashboard/sales-by-period',
        queryParameters: {'period': period},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Sales by Period API Error: $e');
      rethrow;
    }
  }

  // ==================== PRODUCT MANAGEMENT APIs ====================

  /// Get setup data (product types and users)
  Future<Response> getProductSetupData() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/products/setup-data',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Setup Data API Error: $e');
      rethrow;
    }
  }

  /// Create a new product
  Future<Response> createProduct({
    required String name,
    required String code,
    required String unitPrice,
    required String typeId,
    String? imageBase64,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      final data = {
        'name': name,
        'code': code,
        'unit_price': unitPrice,
        'type_id': typeId,
      };

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64;
      }

      return await _dio.post(
        '/admin/products',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Create Product API Error: $e');
      rethrow;
    }
  }

  /// Update an existing product
  Future<Response> updateProduct({
    required int productId,
    required String name,
    required String code,
    required String unitPrice,
    required String typeId,
    String? imageBase64,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      final data = {
        'name': name,
        'code': code,
        'unit_price': unitPrice,
        'type_id': typeId,
      };

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64;
      }

      return await _dio.put(
        '/admin/products/$productId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update Product API Error: $e');
      rethrow;
    }
  }

  /// Delete a product
  Future<Response> deleteProduct({required int productId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.delete(
        '/admin/products/$productId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Delete Product API Error: $e');
      rethrow;
    }
  }

  // ==================== PRODUCT TYPE MANAGEMENT APIs ====================

  /// Get all product types
  Future<Response> getProductTypes() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/products/types/data',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Product Types API Error: $e');
      rethrow;
    }
  }

  /// Create a new product type
  Future<Response> createProductType({
    required String name,
    String? imageBase64,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      final data = {'name': name};

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64;
      }

      return await _dio.post(
        '/admin/product/types',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Create Product Type API Error: $e');
      rethrow;
    }
  }

  /// Update an existing product type
  Future<Response> updateProductType({
    required int typeId,
    required String name,
    String? imageBase64,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      final data = {'name': name};

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64;
      }

      return await _dio.put(
        '/admin/product/types/$typeId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update Product Type API Error: $e');
      rethrow;
    }
  }

  /// Delete a product type
  Future<Response> deleteProductType({required int typeId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.delete(
        '/admin/product/types/$typeId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Delete Product Type API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // USER MANAGEMENT ENDPOINTS
  // ============================================

  /// Get user setup data (roles)
  Future<Response> getUserSetupData() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/users/setup',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ User Setup Data API Error: $e');
      rethrow;
    }
  }

  /// Get all users with optional pagination
  Future<Response> getUsers({int? page, int? limit}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      return await _dio.get(
        '/admin/users',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Get Users API Error: $e');
      rethrow;
    }
  }

  /// Get user by ID
  Future<Response> getUserById({required int userId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Get User By ID API Error: $e');
      rethrow;
    }
  }

  /// Create a new user
  Future<Response> createUser({required Map<String, dynamic> data}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.post(
        '/admin/users',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Create User API Error: $e');
      rethrow;
    }
  }

  /// Update user
  Future<Response> updateUser({
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.put(
        '/admin/users/$userId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update User API Error: $e');
      rethrow;
    }
  }

  /// Update user status (active/inactive)
  Future<Response> updateUserStatus({
    required int userId,
    required bool isActive,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.put(
        '/admin/users/status/$userId',
        data: {'is_active': isActive ? 'true' : 'false'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update User Status API Error: $e');
      rethrow;
    }
  }

  /// Update user password
  Future<Response> updateUserPassword({
    required int userId,
    required String password,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.put(
        '/admin/users/update-password/$userId',
        data: {'confirm_password': password},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update User Password API Error: $e');
      rethrow;
    }
  }

  /// Delete user
  Future<Response> deleteUser({required int userId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.delete(
        '/admin/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Delete User API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // ACCOUNT - PROFILE ENDPOINTS
  // ============================================

  /// Switch role
  Future<Response> switchRole({required int roleId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.post(
        '/account/auth/switch',
        queryParameters: {'role_id': roleId},
        data: {'role_id': roleId.toString()},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Switch Role API Error: $e');
      rethrow;
    }
  }

  // -------- PROFILE ----------
  Future<Response> getProfile() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/account/profile/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Profile API Error: $e');
      rethrow;
    }
  }

  /// Get profile logs
  Future<Response> getProfileLogs({int? page, int? limit}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      return await _dio.get(
        '/account/profile/logs',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Profile Logs API Error: $e');
      rethrow;
    }
  }

  /// Update profile
  Future<Response> updateProfile({required Map<String, dynamic> data}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.put(
        '/account/profile/update',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update Profile API Error: $e');
      rethrow;
    }
  }

  /// Update profile password
  Future<Response> updateProfilePassword({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.put(
        '/account/profile/update-password',
        data: {
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('❌ Update Profile Password API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // ADMIN - SALES ENDPOINTS
  // ============================================

  /// Get sales setup data
  Future<Response> getSalesSetup() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/admin/sales/setup',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Sales Setup API Error: $e');
      rethrow;
    }
  }

  /// Get admin sales list
  Future<Response> getAdminSales({
    String? startDate,
    String? endDate,
    int? cashier,
    String? platform,
    int? page,
    int? limit,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      Map<String, dynamic> queryParams = {};
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (cashier != null) queryParams['cashier'] = cashier;
      if (platform != null) queryParams['platform'] = platform;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      return await _dio.get(
        '/admin/sales',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Admin Sales API Error: $e');
      rethrow;
    }
  }

  /// Delete sale
  Future<Response> deleteSale({required int saleId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.delete(
        '/admin/sales/$saleId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Delete Sale API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // REPORTS ENDPOINTS
  // ============================================

  /// Generate sale report (returns base64 PDF)
  Future<Response> generateSaleReport({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/share/report/generate-sale-report',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Sale Report API Error: $e');
      rethrow;
    }
  }

  /// Generate cashier report (returns base64 PDF)
  Future<Response> generateCashierReport({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/share/report/generate-cashier-report',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Cashier Report API Error: $e');
      rethrow;
    }
  }

  /// Generate product report (returns base64 PDF)
  Future<Response> generateProductReport({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/share/report/generate-product-report',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Product Report API Error: $e');
      rethrow;
    }
  }

  /// Get order invoice PDF (base64)
  Future<Response> getOrderInvoice({required String receiptNumber}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/share/print/order-invoice/$receiptNumber',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Order Invoice API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // CASHIER - ORDER ENDPOINTS
  // ============================================

  /// Get ordering products (grouped by type)
  Future<Response> getOrderingProducts() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/cashier/ordering/products',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Ordering Products API Error: $e');
      rethrow;
    }
  }

  /// Place order
  Future<Response> placeOrder({required List<int> cartIds}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.post(
        '/cashier/ordering/order',
        queryParameters: {'cart': cartIds},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Place Order API Error: $e');
      rethrow;
    }
  }

  // ============================================
  // CASHIER - SALES ENDPOINTS
  // ============================================

  /// Get cashier sales list
  Future<Response> getCashierSales({int? page, int? limit}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      Map<String, dynamic>? queryParams;
      if (page != null || limit != null) {
        queryParams = {};
        if (page != null) queryParams['page'] = page;
        if (limit != null) queryParams['limit'] = limit;
      }

      return await _dio.get(
        '/cashier/sales',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Cashier Sales API Error: $e');
      rethrow;
    }
  }

  /// Get cashier sale by ID
  Future<Response> getCashierSaleById({required int saleId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.get(
        '/cashier/sales/$saleId/view',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Cashier Sale View API Error: $e');
      rethrow;
    }
  }

  /// Delete cashier sale
  Future<Response> deleteCashierSale({required int saleId}) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();

      return await _dio.delete(
        '/cashier/sales/$saleId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print('❌ Delete Cashier Sale API Error: $e');
      rethrow;
    }
  }
}
