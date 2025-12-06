import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_eshop/app/modules/user/ordering/views/product_detail_view.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../controllers/ordering_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../../widgets/product_item.dart';

class OrderingView extends GetView<OrderingController> {
  const OrderingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),

              SizedBox(height: AppSpacing.marginMedium),
              _searchBar(),

              SizedBox(height: AppSpacing.marginMedium),
              _promoBanner(),

              SizedBox(height: AppSpacing.marginLarge),
              _categorySection(),

              SizedBox(height: AppSpacing.marginLarge),
              _sectionTitle("Recommended For You"),

              SizedBox(height: AppSpacing.marginMedium),
              _recommendedProducts(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _bottomNav(cart),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 MODERN HEADER
  // ---------------------------------------------------------------------------
  Widget _header() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: const AssetImage("assets/logo/posmobile1.png"),
        ),
        SizedBox(width: 10),
        Text(
          "Hello 👋",
          style: TextStyle(
            fontSize: AppFontSize.titleLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Icon(Icons.favorite_outline, size: AppWidgetSize.iconMedium),
        SizedBox(width: 16),
        Icon(Icons.shopping_cart_outlined, size: AppWidgetSize.iconMedium),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search products...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 PROMO BANNER (like modern Nike UI)
  // ---------------------------------------------------------------------------
  Widget _promoBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primary,
        image: const DecorationImage(
          image: AssetImage("assets/banner/slider1.jpg"),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Limited Offer",
            style: TextStyle(
              fontSize: AppFontSize.headlineSmall,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "50% Discount on Shoes",
            style: TextStyle(
              color: Colors.white70,
              fontSize: AppFontSize.titleMedium,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Shop Now",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 CATEGORY CHIPS (rounded modern)
  // ---------------------------------------------------------------------------
  Widget _categorySection() {
    return Obx(() {
      return SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length + 1,
          separatorBuilder: (_, __) => SizedBox(width: 10),
          itemBuilder: (_, i) {
            final selected = controller.selectedCategoryIndex.value == i;
            final label = (i == 0) ? "All" : controller.categories[i - 1].name ?? "";

            return GestureDetector(
              onTap: () => controller.selectCategory(i),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSize.bodyMedium,
                    color: selected ? Colors.white : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // 🔹 RECOMMENDED PRODUCTS (Horizontal, Modern Card)
  // ---------------------------------------------------------------------------
  // Widget _recommendedProducts() {
  //   return Obx(() {
  //     if (controller.isLoading.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final items = controller.filteredProducts;
  //
  //     if (items.isEmpty) {
  //       return const Center(child: Text("No products available"));
  //     }
  //
  //     return GridView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: AppSpacing.paddingM,
  //         vertical: AppSpacing.paddingS,
  //       ),
  //
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 16,
  //         crossAxisSpacing: 16,
  //         childAspectRatio: 0.70, // safer ratio to avoid overflow
  //       ),
  //
  //       itemCount: items.length,
  //       itemBuilder: (_, index) {
  //         final product = items[index];
  //
  //         return Container(
  //           decoration: AppColors.cardDecoration(),
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(12),
  //
  //             // ⭐ NAVIGATION FIX ADDED
  //             onTap: () {
  //               Get.to(
  //                     () => const ProductDetailView(),
  //                 arguments: product,
  //               );
  //             },
  //
  //             child: Padding(
  //               padding: EdgeInsets.all(AppSpacing.paddingM),
  //
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,          // 🔥 FIX OVERFLOW
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //
  //                   // ---------- IMAGE ----------
  //                   Flexible(                              // 🔥 FIX OVERFLOW
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(12),
  //                       child: Image.network(
  //                         AppConfig.getImageUrl(product.image),
  //                         width: double.infinity,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //
  //                   SizedBox(height: AppSpacing.marginSmall),
  //
  //                   // ---------- CODE ----------
  //                   Text(
  //                     product.code ?? "",
  //                     style: TextStyle(
  //                       fontSize: AppFontSize.bodySmall,
  //                       fontWeight: FontWeight.w600,
  //                       color: AppColors.lightTextSecondary,
  //                     ),
  //                   ),
  //
  //                   SizedBox(height: AppSpacing.marginXS),
  //
  //                   // ---------- NAME ----------
  //                   Text(
  //                     product.name ?? "",
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontSize: AppFontSize.titleSmall,
  //                       fontWeight: FontWeight.bold,
  //                       color: AppColors.lightTextPrimary,
  //                     ),
  //                   ),
  //
  //                   SizedBox(height: AppSpacing.marginSmall),
  //
  //                   // ---------- PRICE + ADD BUTTON ----------
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "\$${product.unitPrice}",
  //                         style: TextStyle(
  //                           fontSize: AppFontSize.titleMedium,
  //                           fontWeight: FontWeight.bold,
  //                           color: AppColors.primary,
  //                         ),
  //                       ),
  //
  //                       GestureDetector(
  //                         onTap: () => controller.addToCart(product),
  //                         child: Container(
  //                           padding: EdgeInsets.all(AppSpacing.paddingXS),
  //                           decoration: BoxDecoration(
  //                             color: AppColors.primary,
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: const Icon(
  //                             Icons.add,
  //                             color: Colors.white,
  //                             size: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  // ---------------------------------------------------------------------------
  // 🔹 BOTTOM NAVIGATION + CART TOTAL
  // ---------------------------------------------------------------------------

  Widget _recommendedProducts() {
    final cart = Get.find<CartController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = controller.filteredProducts;

      if (items.isEmpty) {
        return const Center(child: Text("No products available"));
      }

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.70,
        ),

        itemCount: items.length,
        itemBuilder: (_, index) {
          final product = items[index];

          // ⭐ EACH CARD MUST HAVE Obx FOR LIVE QTY UPDATE
          return Obx(() {
            final qty = cart.getQuantity(product.id);

            return Container(
              decoration: AppColors.cardDecoration(),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(
                        () => const ProductDetailView(),
                    arguments: product,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingM),

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ─────────── IMAGE ───────────
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            AppConfig.getImageUrl(product.image),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.marginSmall),

                      // ─────────── CODE ───────────
                      Text(
                        product.code ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSize.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.marginXS),

                      // ─────────── NAME ───────────
                      Text(
                        product.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSize.titleSmall,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.marginSmall),

                      // ─────────── PRICE + QTY ───────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.unitPrice}",
                            style: TextStyle(
                              fontSize: AppFontSize.titleMedium,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          qty == 0
                              ? _addButton(() => cart.addItem(product))
                              : _qtySelector(
                            qty: qty,
                            onIncrease: () => cart.addItem(product),
                            onDecrease: () => cart.decreaseItem(product),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
              ),
            );
          });
        },
      );
    });
  }


  Widget _addButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingXS),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _qtySelector({
    required int qty,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrease,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.paddingXS),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
            ),
            child: const Icon(Icons.remove, size: 16, color: Colors.white),
          ),
        ),
        SizedBox(width: 6),
        Text(
          qty.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 6),
        GestureDetector(
          onTap: onIncrease,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.paddingXS),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }


  Widget _buildQtyControl({
    required int qty,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrease,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.paddingXS),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.remove, size: 16, color: Colors.white),
          ),
        ),
        SizedBox(width: 6),
        Text(
          qty.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 6),
        GestureDetector(
          onTap: onIncrease,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.paddingXS),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }




  Widget _bottomNav(CartController cart) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: Row(
          children: [
            // Cart icon with count
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: AppWidgetSize.iconXL, color: AppColors.primary),
                if (cart.items.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.items.length.toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),

            SizedBox(width: AppSpacing.marginMedium),

            Text(
              "${cart.total.value} ៛",
              style: TextStyle(
                fontSize: AppFontSize.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () => Get.toNamed("/user/cart"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Cart"),
            ),
          ],
        ),
      );
    });
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppFontSize.headlineSmall,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
