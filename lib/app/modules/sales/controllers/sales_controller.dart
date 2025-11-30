import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/cashier_sale_model.dart';
import '../../../data/providers/cashier_provider.dart';
import '../../../routes/app_routes.dart';

class SalesController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

  var sales = <SaleData>[].obs;
  var groupedSales = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var totalToday = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  // ===========================
  // FETCH SALES FROM API
  // ===========================
  Future<void> fetchSales() async {
    try {
      isLoading(true);

      final response = await cashierProvider.getSales(page: 1);
      final list = response.data ?? [];

      sales.assignAll(list);

      calculateTodayTotal();
      groupSalesByDate();

    } catch (e) {
      print("❌ Fetch sales error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ===========================
  // CALCULATE TODAY TOTAL
  // ===========================
  void calculateTodayTotal() {
    int sum = 0;

    final nowLocal = DateTime.now();
    final today = DateFormat("yyyy-MM-dd").format(nowLocal);

    for (final s in sales) {
      if (s.orderedAt == null) continue;

      // Convert UTC → LOCAL
      final utc = DateTime.parse(s.orderedAt!);
      final local = utc.toLocal();

      final saleDate = DateFormat("yyyy-MM-dd").format(local);

      if (saleDate == today) {
        sum += s.totalPrice ?? 0;
      }
    }

    totalToday.value = sum;
  }

  // ===========================
  // GROUP SALES BY DATE
  // ===========================
  void groupSalesByDate() {
    final Map<String, List<SaleData>> map = {};

    for (var sale in sales) {
      if (sale.orderedAt == null) continue;

      final dateString = sale.orderedAt!.split("T").first; // 2025-11-18
      map.putIfAbsent(dateString, () => []).add(sale);
    }

    final result = map.entries.map((e) {
      return {
        "date": formatHeaderDate(e.key),   // "September 14"
        "items": e.value,
      };
    }).toList();

    // Sort by date (descending)
    result.sort((a, b) =>
        b["date"].toString().compareTo(a["date"].toString()));

    groupedSales.assignAll(result);
  }

  // Convert "2025-11-18" → "September 14"
  String formatHeaderDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat("MMMM d").format(date);
  }

  // ===========================
  // OPEN SALE DETAIL
  // ===========================
  void openSaleDetail(int id) {
    Get.toNamed(Routes.SALE_DETAIL, arguments: id);
  }
}
