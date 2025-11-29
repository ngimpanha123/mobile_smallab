import 'package:get/get.dart';
import '../../../data/models/cashier_sale_model.dart';
import '../../../data/providers/cashier_provider.dart';
import '../../../routes/app_routes.dart';

class SalesController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

  var sales = <SaleData>[].obs;
  var isLoading = false.obs;
  var totalToday = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  Future<void> fetchSales() async {
    try {
      isLoading(true);
      final response = await cashierProvider.getSales(page: 1);
      sales.assignAll(response.data ?? []);

      // Calculate today total
      int sum = 0;
      for (final s in sales) {
        sum += s.totalPrice ?? 0;
      }
      totalToday.value = sum;
    } catch (e) {
      print('Fetch sales error: $e');
    } finally {
      isLoading(false);
    }
  }

  void openSaleDetail(int id) {
    Get.toNamed(Routes.SALE_DETAIL, arguments: id);
  }
}
