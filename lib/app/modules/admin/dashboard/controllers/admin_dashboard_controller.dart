import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/admin/dashboard_model.dart';
import '../../../../data/providers/admin_provider.dart';


class DashboardController extends GetxController {
  final _api = Get.find<AdminProvider>();

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var selectedDate = DateTime.now().obs;

  // Dashboard data
  Rx<Statistic?> statistic = Rx<Statistic?>(null);
  Rx<SalesData?> salesData = Rx<SalesData?>(null);
  Rx<ProductTypeData?> productTypeData = Rx<ProductTypeData?>(null);
  RxList<CashierInfo> cashierList = <CashierInfo>[].obs;

  // Period summaries
  var todayTotal = 0.0.obs;
  var weekTotal = 0.0.obs;
  var monthTotal = 0.0.obs;
  var sixMonthsTotal = 0.0.obs;
  var selectedPeriod = 'week'.obs; // default to week

  // Cashier view toggles
  var cashierListView = true.obs;
  var cashierChartView = false.obs;
  var cashierBarView = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchAllPeriodTotals();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final today = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final res = await _api.getDashboard(today: today);

      if (res.statusCode == 200 && res.data['dashboard'] != null) {
        final dashboardResponse = DashboardResponse.fromJson(res.data);
        statistic.value = dashboardResponse.dashboard.statistic;
        salesData.value = dashboardResponse.dashboard.salesData;
        productTypeData.value = dashboardResponse.dashboard.productTypeData;
        cashierList.value = dashboardResponse.dashboard.cashierData.data;

        // Calculate period totals from loaded data
        calculatePeriodTotalsFromSalesData();
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load dashboard (${res.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchDashboardData();
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(2)}%';
  }

  // Fetch all period totals
  Future<void> fetchAllPeriodTotals() async {
    await Future.wait([
      fetchPeriodTotal('today'),
      fetchPeriodTotal('week'),
      fetchPeriodTotal('month'),
      fetchPeriodTotal('6months'),
    ]);
  }

  // Fetch total for specific period
  Future<void> fetchPeriodTotal(String period) async {
    try {
      // For today, use the existing statistic total
      if (period == 'today') {
        todayTotal.value = statistic.value?.total ?? 0.0;
        return;
      }

      // For week, calculate from salesData (which is weekly data)
      if (period == 'week' && salesData.value != null) {
        weekTotal.value = salesData.value!.data.fold(0.0, (sum, value) => sum + value);
        return;
      }

      // For other periods, fetch from API
      final res = await _api.getSalesByPeriod(period: period);

      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;

        // Handle different response formats
        if (data is Map && data.containsKey('total')) {
          final total = (data['total'] ?? 0).toDouble();
          _updatePeriodTotal(period, total);
        } else if (data is Map && data.containsKey('data')) {
          // If response contains data array, sum it up
          final dataList = List<double>.from((data['data'] as List).map((e) => (e ?? 0).toDouble()));
          final total = dataList.fold(0.0, (sum, value) => sum + value);
          _updatePeriodTotal(period, total);
        }
      }
    } catch (e) {
      print('❌ Error fetching $period total: $e');
      // Keep existing value or set to 0
    }
  }

  void _updatePeriodTotal(String period, double total) {
    switch (period) {
      case 'today':
        todayTotal.value = total;
        break;
      case 'week':
        weekTotal.value = total;
        break;
      case 'month':
        monthTotal.value = total;
        break;
      case '6months':
        sixMonthsTotal.value = total;
        break;
    }
  }

  // Calculate totals from current salesData
  void calculatePeriodTotalsFromSalesData() {
    if (salesData.value != null) {
      // Week total (sum all days in the week)
      weekTotal.value = salesData.value!.data.fold(0.0, (sum, value) => sum + value);

      // Today total (use from statistic)
      todayTotal.value = statistic.value?.total ?? 0.0;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }

  // View toggle methods for cashier section
  void showCashierListView() {
    cashierListView.value = true;
    cashierChartView.value = false;
    cashierBarView.value = false;
  }

  void showCashierChartView() {
    cashierListView.value = false;
    cashierChartView.value = true;
    cashierBarView.value = false;
  }

  void showCashierBarView() {
    cashierListView.value = false;
    cashierChartView.value = false;
    cashierBarView.value = true;
  }

  Future<void> showDatePicker() async {
    final pickedDate = await Get.dialog<DateTime>(
      AlertDialog(
        title: const Text('Choose a date'),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today'),
              onTap: () => Get.back(result: DateTime.now()),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Yesterday'),
              onTap: () => Get.back(
                result: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Last week'),
              onTap: () => Get.back(
                result: DateTime.now().subtract(const Duration(days: 7)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Choose a different date'),
              onTap: () async {
                Get.back();
                final date = await _showMaterialDatePicker();
                if (date != null) {
                  changeDate(date);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (pickedDate != null) {
      changeDate(pickedDate);
    }
  }

  Future<DateTime?> _showMaterialDatePicker() async {
    return await Get.generalDialog<DateTime>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CalendarDatePicker(
          initialDate: selectedDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          onDateChanged: (date) => Get.back(result: date),
        );
      },
    );
  }
}
