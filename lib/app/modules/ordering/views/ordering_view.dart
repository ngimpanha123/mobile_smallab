import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ordering_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../widgets/product_item.dart';

class OrderingView extends GetView<OrderingController> {
  const OrderingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // ░░ TOP HEADER (Logo + bell + arrow) ░░
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logo/posmobile1.png",
                    height: 38,
                  ),
                  const Spacer(),
                  // Notification icon with red dot (as screenshot)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Icon(Icons.notifications_none,
                          size: 28, color: Colors.black87),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 18),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 32, color: Colors.black87),
                ],
              ),
            ),

            // ░░ CATEGORY FILTER TABS (Rounded Pills) ░░
            Obx(() {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length + 1,
                  itemBuilder: (_, i) {
                    final isSelected =
                        controller.selectedCategoryIndex.value == i;

                    final label = (i == 0)
                        ? "All"
                        : controller.categories[i - 1].name ?? "";

                    return GestureDetector(
                      onTap: () => controller.selectCategory(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0A75D7)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0A75D7)
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 8),

            // ░░ PRODUCT LIST (Matches screenshot) ░░
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return const Center(
                      child: Text("No products",
                          style:
                          TextStyle(color: Colors.grey, fontSize: 16)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (_, index) {
                    return ProductItemWidget(
                      product: controller.filteredProducts[index],
                      onAdd: () => controller.addToCart(
                        controller.filteredProducts[index],
                      ),
                    );
                  },
                );
              }),
            ),

            // ░░ FOOTER CART SECTION ░░
            Obx(() {
              final totalItems = cart.items.length;
              final totalPrice = cart.total.value;

              return Container(
                height: 78,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                child: Row(
                  children: [
                    // Left circle count EXACT like screenshot
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0A75D7),
                      ),
                      child: Center(
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Middle: total price
                    Expanded(
                      child: Text(
                        "$totalPrice ៛",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Button EXACT like screenshot
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed("/cart"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A75D7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        child: const Text(
                          "កន្ត្រកបញ្ជា",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
