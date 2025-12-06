import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/cashier_product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductItem product = Get.arguments;
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ------------------ TOP BAR ------------------
            Padding(
              padding: EdgeInsets.all(AppSpacing.paddingM),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.arrow_back, size: 22),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.favorite_border, size: 28),
                ],
              ),
            ),

            // ------------------ MAIN CONTENT ------------------
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------ PRODUCT IMAGE ------------------
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          AppConfig.getImageUrl(product.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginLarge),

                    // ------------------ CODE + CATEGORY ------------------
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.code ?? "",
                            style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          product.type?.name ?? "",
                          style: TextStyle(
                            fontSize: AppFontSize.bodySmall,
                            color: AppColors.lightTextSecondary,
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: AppSpacing.marginSmall),

                    // ------------------ PRODUCT NAME ------------------
                    Text(
                      product.name ?? "",
                      style: TextStyle(
                        fontSize: AppFontSize.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginSmall),

                    // ------------------ PRICE + INLINE QTY ------------------
                    Obx(() {
                      final qty = cart.getQuantity(product.id);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.unitPrice}",
                            style: TextStyle(
                              fontSize: AppFontSize.headlineMedium,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          // ⭐ If qty = 0 → show Add (+)
                          if (qty == 0)
                            GestureDetector(
                              onTap: () => cart.addItem(product),
                              child: Container(
                                padding: EdgeInsets.all(AppSpacing.paddingS),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add,
                                    size: 26, color: Colors.white),
                              ),
                            )
                          else
                          // ⭐ If qty > 0 → show QUANTITY CONTROL
                            Row(
                              children: [
                                _qtyInlineBtn(
                                  Icons.remove,
                                      () => cart.decreaseItem(product),
                                ),
                                SizedBox(width: AppSpacing.marginSmall),
                                Text(
                                  qty.toString(),
                                  style: TextStyle(
                                    fontSize: AppFontSize.titleMedium,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.marginSmall),
                                _qtyInlineBtn(
                                  Icons.add,
                                      () => cart.addItem(product),
                                ),
                              ],
                            ),
                        ],
                      );
                    }),

                    SizedBox(height: AppSpacing.marginLarge),

                    // ------------------ DESCRIPTION ------------------
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: AppFontSize.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.marginSmall),

                    Text(
                      "This is a placeholder description. You can update this "
                          "later with real product descriptions from your backend.",
                      style: TextStyle(
                        fontSize: AppFontSize.bodyMedium,
                        color: AppColors.lightTextSecondary,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginXL),
                  ],
                ),
              ),
            ),

            // ------------------ BOTTOM CART ACTION BAR ------------------
            Obx(() {
              final qty = cart.getQuantity(product.id);

              return Container(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    // qty controls if product already in cart
                    qty > 0
                        ? Row(
                      children: [
                        _qtyBtn(Icons.remove,
                                () => cart.decreaseItem(product)),
                        SizedBox(width: AppSpacing.marginSmall),
                        Text(
                          qty.toString(),
                          style: TextStyle(
                            fontSize: AppFontSize.titleMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.marginSmall),
                        _qtyBtn(
                            Icons.add, () => cart.addItem(product)),
                      ],
                    )
                        : Container(),

                    const Spacer(),

                    // bottom button
                    ElevatedButton(
                      onPressed: () {
                        if (qty == 0) {
                          cart.addItem(product);
                        } else {
                          Get.toNamed('/user/cart'); // ⭐ GO TO CART
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingXL,
                          vertical: AppSpacing.paddingSM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        qty == 0 ? "Add to Cart" : "More",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  // ------------------ INLINE QTY BUTTON ------------------
  Widget _qtyInlineBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingXS),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // ------------------ BOTTOM BAR QTY BUTTON ------------------
  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingXS),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Icon(
          icon,
          size: AppWidgetSize.iconSmall,
          color: Colors.white,
        ),
      ),
    );
  }
}

