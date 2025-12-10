import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      // ░░ TOP BAR ░░
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightBackground,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            size: AppWidgetSize.iconLarge,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Order Item",
          style: TextStyle(
            fontSize: AppFontSize.titleLarge,
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [

          // ░░ CART LIST ░░
          Expanded(
            child: Obx(() {
              if (controller.items.isEmpty) {
                return Center(
                  child: Text(
                    "No items in the cart",
                    style: TextStyle(
                      fontSize: AppFontSize.titleMedium,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                );
              }

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
                children: controller.items.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;

                  return CartItemWidget(
                    product: product,
                    qty: qty,
                    onIncrease: () => controller.addItem(product),
                    onDecrease: () => controller.decreaseItem(product),
                    onDelete: () => controller.removeProduct(product),
                  );
                }).toList(),
              );
            }),
          ),

          // ░░ BOTTOM SECTION (Total + Buttons) ░░
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingM,
              vertical: AppSpacing.paddingSM,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lightBackground,
              border: Border(
                top: BorderSide(color: Colors.black12),
              ),
            ),
            child: Column(
              children: [

                // ░░ TOTAL ROW ░░
                Row(
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: AppFontSize.titleMedium,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                          () => Text(
                        "${controller.total.value} ៛",
                        style: TextStyle(
                          fontSize: AppFontSize.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.marginMedium),

                // ░░ BUTTON: PAY WITH BAKONG KHQR ░░
                // Pay with KHQR
                GestureDetector(
                  onTap: () async => controller.callKhqrPayment(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Pay with Bakong KHQR",
                        style: TextStyle(
                          fontSize: AppFontSize.titleMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.marginMedium),

                // ░░ BUTTON: NORMAL CHECKOUT ░░
                GestureDetector(
                  onTap: () async {
                    await controller.callNormalPayment();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.paddingSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.paddingL,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Normal Checkout",
                        style: TextStyle(
                          fontSize: AppFontSize.titleMedium,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: AppSpacing.marginXXL),
        ],
      ),
    );
  }
}
