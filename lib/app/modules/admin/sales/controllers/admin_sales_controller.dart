import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/admin/sale_model.dart';
import '../../../../data/models/admin/sales_setup_model.dart';
import '../../../../data/providers/admin_provider.dart';

class AdminSalesController extends GetxController {
  final _api = Get.find<AdminProvider>();

  // Observable variables
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Sales data
  RxList<SaleModel> salesList = <SaleModel>[].obs;
  Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  // Setup data
  RxList<CashierOption> cashiers = <CashierOption>[].obs;
  RxList<SortItem> sortItems = <SortItem>[].obs;

  // Filter options
  var selectedStartDate = Rx<DateTime?>(null);
  var selectedEndDate = Rx<DateTime?>(null);
  var selectedCashier = Rx<int?>(null);
  var selectedPlatform = Rx<String?>(null);
  var currentPage = 1.obs;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchSetupData();
    fetchSales();
  }

  /// Fetch setup data (cashiers and sort items)
  Future<void> fetchSetupData() async {
    try {
      final res = await _api.getSalesSetup();

      if (res.statusCode == 200 && res.data != null) {
        final setupData = SalesSetupData.fromJson(res.data);
        cashiers.value = setupData.cashiers;
        sortItems.value = setupData.sortItems;
      }
    } catch (e) {
      print('❌ Error fetching setup data: $e');
    }
  }

  /// Fetch sales list with filters
  Future<void> fetchSales({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoading.value = true;
      }
      hasError.value = false;
      errorMessage.value = '';

      final res = await _api.getAdminSales(
        startDate: selectedStartDate.value != null
            ? DateFormat('yyyy-MM-dd').format(selectedStartDate.value!)
            : null,
        endDate: selectedEndDate.value != null
            ? DateFormat('yyyy-MM-dd').format(selectedEndDate.value!)
            : null,
        cashier: selectedCashier.value,
        platform: selectedPlatform.value,
        page: currentPage.value,
        limit: limit,
      );

      if (res.statusCode == 200 && res.data != null) {
        salesList.value = (res.data['data'] as List<dynamic>?)
            ?.map((sale) => SaleModel.fromJson(sale))
            .toList() ??
            [];
        pagination.value = PaginationModel.fromJson(res.data['pagination'] ?? {});
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load sales (${res.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Apply filters
  void applyFilters({
    DateTime? startDate,
    DateTime? endDate,
    int? cashierId,
    String? platform,
  }) {
    selectedStartDate.value = startDate;
    selectedEndDate.value = endDate;
    selectedCashier.value = cashierId;
    selectedPlatform.value = platform;
    currentPage.value = 1;
    fetchSales();
  }

  /// Clear filters
  void clearFilters() {
    selectedStartDate.value = null;
    selectedEndDate.value = null;
    selectedCashier.value = null;
    selectedPlatform.value = null;
    currentPage.value = 1;
    fetchSales();
  }

  /// Change page
  void changePage(int page) {
    if (page >= 1 && page <= (pagination.value?.totalPage ?? 1)) {
      currentPage.value = page;
      fetchSales(showLoading: false);
    }
  }

  /// Delete sale
  Future<bool> deleteSale(int saleId) async {
    try {
      final res = await _api.deleteSale(saleId: saleId);

      if (res.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Sale deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchSales(showLoading: false);
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete sale',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Get order invoice PDF
  Future<String?> getOrderInvoice(String receiptNumber) async {
    try {
      final res = await _api.getOrderInvoice(receiptNumber: receiptNumber);

      if (res.statusCode == 200 && res.data != null) {
        return res.data['data'] as String?; // base64 PDF
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get invoice',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  /// Format date
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Refresh data
  Future<void> refreshData() async {
    await Future.wait([
      fetchSetupData(),
      fetchSales(showLoading: false),
    ]);
  }
}
