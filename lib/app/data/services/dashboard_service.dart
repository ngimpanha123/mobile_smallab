import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import '../models/admin/dashboard_model.dart';

class DashboardService extends GetxService {
  final Logger _logger = Logger();

  // Use 10.0.2.2 for Android Emulator (maps to host machine's localhost)
  // For physical device, replace with your computer's IP address (e.g., 192.168.1.100)
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:9055/api/admin',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<DashboardResponse?> getDashboardData(String today) async {
    try {
      final response = await _dio.get(
        '/dashboard',
        queryParameters: {'today': today},
      );

      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching dashboard data', error: e);
      return null;
    }
  }

  Future<List<CashierInfo>> getCashierData(String today) async {
    try {
      final response = await _dio.get(
        '/dashboard/cashier',
        queryParameters: {'today': today},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => CashierInfo.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      _logger.e('Error fetching cashier data', error: e);
      return [];
    }
  }

  Future<ProductTypeData?> getProductTypeData(String thisMonth) async {
    try {
      final response = await _dio.get(
        '/dashboard/product-type',
        queryParameters: {'thisMonth': thisMonth},
      );

      if (response.statusCode == 200) {
        return ProductTypeData.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching product type data', error: e);
      return null;
    }
  }

  Future<SalesData?> getSalesData() async {
    try {
      final response = await _dio.get('/dashboard/data-sale');

      if (response.statusCode == 200) {
        return SalesData.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching sales data', error: e);
      return null;
    }
  }
}
