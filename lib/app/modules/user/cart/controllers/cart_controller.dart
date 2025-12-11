import 'package:get/get.dart';
import 'package:mobile_eshop/app/data/models/cashier_order_model.dart';

import '../../../../data/models/cashier_product_model.dart';
import '../../../../data/providers/cashier_provider.dart';
import '../../../../data/repositories/khqr_repository.dart';

class CartController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();
  final khqrRepo = Get.find<KhqrRepository>(); // ✅ FIXED

  var items = <ProductItem, int>{}.obs;
  var total = 0.obs;

  // ------------------------------------------------------
  // ADD ITEM
  // ------------------------------------------------------
  void addItem(ProductItem product) {
    if (items.containsKey(product)) {
      items[product] = items[product]! + 1;
    } else {
      items[product] = 1;
    }
    calculateTotal();
  }

  // ------------------------------------------------------
  // DECREASE ITEM
  // ------------------------------------------------------
  void decreaseItem(ProductItem product) {
    if (!items.containsKey(product)) return;

    if (items[product] == 1) {
      items.remove(product);
    } else {
      items[product] = items[product]! - 1;
    }
    calculateTotal();
  }

  // ------------------------------------------------------
  // REMOVE PRODUCT
  // ------------------------------------------------------
  void removeProduct(ProductItem product) {
    if (items.containsKey(product)) {
      items.remove(product);
    }
    calculateTotal();
  }


  void clearCart() {
    items.clear();
    total.value = 0;
  }

  // ------------------------------------------------------
  // CALCULATE TOTAL
  // ------------------------------------------------------
  void calculateTotal() {
    int sum = 0;
    items.forEach((product, qty) {
      sum += (product.unitPrice ?? 0) * qty;
    });
    total(sum);
  }

  // ------------------------------------------------------
  // NORMAL CHECKOUT (CASH)
  // ------------------------------------------------------
  Future<void> callNormalPayment() async {
    if (items.isEmpty) return;

    Map<String, int> cartMap = {};
    items.forEach((p, qty) {
      cartMap[(p.id ?? 0).toString()] = qty;
    });

    final order = await cashierProvider.sendOrder(cartMap);

    if (order != null) {
      Get.offNamed("/user/success", arguments: order);
    }
  }

  // ------------------------------------------------------
  // ✅ KHQR PAYMENT (FIXED)
  // ------------------------------------------------------
  Future<void> callKhqrPayment() async {
    if (items.isEmpty) return;

    Map<String, int> cartMap = {};
    items.forEach((product, qty) {
      cartMap[(product.id ?? 0).toString()] = qty;
    });

    final repo = Get.find<KhqrRepository>();
    final result = await repo.generateKhqr(cartMap);

    // ✅ ALWAYS pass MAP
    Get.toNamed("/user/khqr", arguments: {
      "result": result,
      "cart": cartMap,
    });
  }

  // ------------------------------------------------------
  // GET QUANTITY BY PRODUCT ID
  // ------------------------------------------------------
  int getQuantity(int? productId) {
    if (productId == null) return 0;

    for (var entry in items.entries) {
      if (entry.key.id == productId) {
        return entry.value;
      }
    }
    return 0;
  }
}
