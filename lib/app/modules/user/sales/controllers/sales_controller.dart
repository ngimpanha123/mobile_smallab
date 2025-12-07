import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/cashier_sale_model.dart';
import '../../../../data/providers/cashier_provider.dart';
import '../../../../routes/app_routes.dart';

class SalesController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

  var sales = <SaleData>[].obs;
  var groupedSales = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var totalToday = 0.obs;

  // RANGE FILTER
  var rangeStart = Rxn<DateTime>();
  var rangeEnd = Rxn<DateTime>();
  var totalRange = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  String formatTime(String? orderedAt) {
    if (orderedAt == null) return "--:--";

    try {
      final dt = DateTime.parse(orderedAt).toLocal();
      return DateFormat("hh:mm a").format(dt);
    } catch (e) {
      print("⛔ Time format error: $e | value: $orderedAt");
      return "--:--";
    }
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

  void calculateRangeTotal() {
    if (rangeStart.value == null || rangeEnd.value == null) {
      totalRange.value = 0;
      return;
    }

    int sum = 0;

    for (final sale in sales) {
      if (sale.orderedAt == null) continue;

      final dt = DateTime.parse(sale.orderedAt!).toLocal();

      if (dt.isAfter(rangeStart.value!) &&
          dt.isBefore(rangeEnd.value!.add(const Duration(days: 1)))) {
        sum += sale.totalPrice ?? 0;
      }
    }

    totalRange.value = sum;
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
