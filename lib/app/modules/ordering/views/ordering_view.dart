import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font_size.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_widget_size.dart';
import '../controllers/ordering_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../widgets/product_item.dart';

class OrderingView extends GetView<OrderingController> {
  const OrderingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [

            // ░░ TOP BAR ░░
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingM,
                vertical: AppSpacing.paddingS,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logo/posmobile1.png",
                    height: AppWidgetSize.logoSmall,
                  ),
                  const Spacer(),

                  // NOTIFICATION ICON
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: AppWidgetSize.iconLarge,
                        color: AppColors.iconColor,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: AppSpacing.paddingS),

                  Icon(
                    Icons.keyboard_arrow_down,
                    size: AppWidgetSize.iconXL,
                    color: AppColors.iconColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.marginSmall),

            // ░░ CATEGORY FILTER ░░
            Obx(() {
              return SizedBox(
                height: 44, // fixed height as in Figma
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                  ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingM,
                          vertical: AppSpacing.paddingS,
                        ),
                        margin: EdgeInsets.only(
                          right: AppSpacing.marginSmall,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(AppSpacing.paddingL),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: AppFontSize.titleSmall,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: AppSpacing.marginSmall),

            // ░░ PRODUCT LIST ░░
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No products available",
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                  ),
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

            // ░░ FOOTER CART BAR ░░
            Obx(() {
              return Container(
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

                // ⋙⋙ ENTIRE BLUE BAR IS TAPPABLE ⋘⋘
                child: GestureDetector(
                  onTap: () => Get.toNamed("/cart"),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM,
                      vertical: AppSpacing.paddingSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.paddingM),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              cart.items.length.toString(),
                              style: TextStyle(
                                fontSize: AppFontSize.titleSmall,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: AppSpacing.marginMedium),

                        Text(
                          "Ordering Now",
                          style: TextStyle(
                            fontSize: AppFontSize.titleMedium,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          "${cart.total.value} ៛",
                          style: TextStyle(
                            fontSize: AppFontSize.headlineSmall,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })

          ],
        ),
      ),
    );
  }
}
