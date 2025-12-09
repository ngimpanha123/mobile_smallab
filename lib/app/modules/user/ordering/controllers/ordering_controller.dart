import 'package:get/get.dart';
import '../../../../data/models/cashier_product_model.dart';
import '../../../../data/providers/cashier_provider.dart';
import '../../cart/controllers/cart_controller.dart';

class OrderingController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();
  final cart = Get.find<CartController>();

  var categories = <CashierCategory>[].obs;
  var selectedCategoryIndex = 0.obs;
  var isLoading = false.obs;

  var filteredProducts = <ProductItem>[].obs;
  var allProducts = <ProductItem>[].obs;

  // ⭐ NEW: favorites list
  var favoriteProducts = <ProductItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final data = await cashierProvider.getCashierProducts();
      categories.assignAll(data.data ?? []);

      allProducts.clear();
      for (var cat in categories) {
        allProducts.addAll(cat.products ?? []);
      }

      filteredProducts.assignAll(allProducts);
    } catch (e) {
      print("❌ Fetch Product Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ==========================
  // FAVORITES LOGIC
  // ==========================

  bool isFavorite(ProductItem item) {
    return favoriteProducts.any((p) => p.id == item.id);
  }

  void selectCategory(int index) {
    selectedCategoryIndex(index);

    if (index == 0) {
      filteredProducts.assignAll(allProducts);
      return;
    }

    final category = categories[index - 1];
    filteredProducts.assignAll(category.products ?? []);
  }

  void addToCart(ProductItem item) {
    cart.addItem(item);
  }
}
