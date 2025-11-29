import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "បញ្ជីទំនិញ",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.items.isEmpty) {
                return const Center(
                    child: Text("មិនមានទំនិញទេ", style: TextStyle(fontSize: 18))
                );
              }

              return ListView(
                padding: EdgeInsets.zero,
                children: controller.items.keys.map((product) {
                  return CartItemWidget(
                    product: product,
                    qty: controller.items[product]!,
                    onIncrease: () => controller.addItem(product),
                    onDecrease: () => controller.decreaseItem(product),
                    onDelete: () => controller.removeProduct(product),
                  );
                }).toList(),
              );
            }),
          ),

          // --------- FOOTER ----------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black12),
              ),
            ),
            child: Column(
              children: [
                // TOTAL ROW
                Row(
                  children: [
                    const Text(
                      "តម្លៃសរុប",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Obx(() => Text(
                      "${controller.total} ៛",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    )),
                  ],
                ),

                const SizedBox(height: 12),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final receipt = await controller.checkout();
                      if (receipt != null) {
                        Get.offNamed("/success", arguments: receipt);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0C8CE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      "បញ្ជូន",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
