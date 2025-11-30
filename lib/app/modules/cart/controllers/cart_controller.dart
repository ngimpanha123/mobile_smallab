import 'package:get/get.dart';
import 'package:mobile_eshop/app/data/models/cashier_order_model.dart';
import 'dart:convert';

import '../../../data/models/cashier_product_model.dart';
import '../../../data/providers/cashier_provider.dart';

class CartController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

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
  // CHECKOUT — UPDATED ✔
  // Backend expects:
  //
  //  "cart": "{\"1\":2,\"2\":3}",
  //  "platform": "Mobile"
  //
  // ------------------------------------------------------
  /* Future<String?> checkout() async {
    if (items.isEmpty) return null;

    // Build map: { productId: qty }
    Map<String, int> cartMap = {};

    items.forEach((product, qty) {
      cartMap[(product.id ?? 0).toString()] = qty;
    });

    // Call provider
    final receipt = await cashierProvider.sendOrder(cartMap);

    return receipt?.receiptNumber;
  } */

  Future<OrderData?> checkout() async {
    if (items.isEmpty) return null;

    // Build map: { productId: qty }
    Map<String, int> cartMap = {};

    items.forEach((product, qty) {
      cartMap[(product.id ?? 0).toString()] = qty;
    });

    // Send order to API
    final response = await cashierProvider.sendOrder(cartMap);

    // Make sure it's not null
    if (response == null) return null;

    // Return entire backend JSON (SuccessView needs full data)
    return response;
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
