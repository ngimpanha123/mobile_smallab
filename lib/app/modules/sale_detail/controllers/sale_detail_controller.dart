import 'package:get/get.dart';
import '../../../data/models/cashier_sale_model.dart';
import '../../../data/models/cashier_sale_view_model.dart';
import '../../../data/providers/cashier_provider.dart';

class SaleDetailController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

  var sale = Rxn<SaleData>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSaleDetail();
  }

  Future<void> loadSaleDetail() async {
    try {
      isLoading(true);
      int saleId = Get.arguments;

      final response = await cashierProvider.getSaleView(saleId);
      sale(response.data);

    } catch (e) {
      print("❌ Sale Detail Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
