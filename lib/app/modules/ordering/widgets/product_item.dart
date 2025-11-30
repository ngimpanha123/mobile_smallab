import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_font_size.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_widget_size.dart';
import '../../../data/models/cashier_product_model.dart';
import '../../cart/controllers/cart_controller.dart';


class ProductItemWidget extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onAdd;

  const ProductItemWidget({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      final qty = cart.getQuantity(product.id);

      return Container(
        margin: EdgeInsets.symmetric(vertical: AppSpacing.marginSmall),
        padding: EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.paddingM),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.paddingS),
              child: Image.network(
                AppConfig.getImageUrl(product.image),
                width: AppWidgetSize.imageSmall,
                height: AppWidgetSize.imageSmall,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: AppSpacing.marginMedium),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product.type?.name ?? ''} | ${product.code ?? ''}",
                    style: TextStyle(
                      fontSize: AppFontSize.bodySmall,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginXS),

                  Text(
                    product.name ?? "",
                    style: TextStyle(
                      fontSize: AppFontSize.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginXS),

                  Text(
                    "${product.unitPrice ?? 0} ៛",
                    style: TextStyle(
                      fontSize: AppFontSize.bodyMedium,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity buttons
            qty == 0
                ? GestureDetector(
              onTap: onAdd,
              child: Icon(
                Icons.add_circle,
                size: AppWidgetSize.iconXL,
                color: AppColors.primary,
              ),
            )
                : Row(
              children: [
                // Minus Button
                GestureDetector(
                  onTap: () => cart.decreaseItem(product),
                  child: _circleBtn(Icons.remove),
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

                // Plus Button
                GestureDetector(
                  onTap: () => cart.addItem(product),
                  child: _circleBtn(Icons.add),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _circleBtn(IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingXS),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF5C6A82), // matches screenshot blue-grey
      ),
      child: Icon(
        icon,
        size: AppWidgetSize.iconSmall,
        color: Colors.white,
      ),
    );
  }
}
