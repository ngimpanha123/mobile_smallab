import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../config/app_config.dart';
import '../services/storage_service.dart';

class AdminDashboardProvider extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {"Accept": "application/json"},
  ));

  final storage = Get.find<StorageService>();

  AdminDashboardProvider(Dio dio);

  Map<String, String> _authHeaders() => {
    "Authorization": "Bearer ${storage.readToken()}"
  };

  // -----------------------------------------------
  // GET Summary
  // -----------------------------------------------
  Future<Response> getDashboardSummary({required String date}) async {
    return _dio.get(
      "/admin/dashboard",
      queryParameters: {"yesterday": date},
      options: Options(headers: _authHeaders()),
    );
  }

  // -----------------------------------------------
  // GET Product Type Stats
  // -----------------------------------------------
  Future<Response> getProductTypeStats({
    required int week,
    required int year,
  }) async {
    return _dio.get(
      "/admin/dashboard/product-type",
      queryParameters: {"week": week, "year": year},
      options: Options(headers: _authHeaders()),
    );
  }

  // -----------------------------------------------
  // GET Cashier Stats
  // -----------------------------------------------
  Future<Response> getCashierStats() async {
    return _dio.get(
      "/admin/dashboard/cashier",
      options: Options(headers: _authHeaders()),
    );
  }

  // -----------------------------------------------
  // GET Data Sale (Bar Chart)
  // -----------------------------------------------
  Future<Response> getDataSale({
    required String sixMonthAgo,
  }) async {
    return _dio.get(
      "/admin/dashboard/data-sale",
      queryParameters: {"sixMonthAgo": sixMonthAgo},
      options: Options(headers: _authHeaders()),
    );
  }
}
