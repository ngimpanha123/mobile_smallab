import 'package:flutter/material.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_font_size.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_widget_size.dart';
import '../../../config/app_config.dart';
import '../../../data/models/cashier_product_model.dart';

class CartItemWidget extends StatelessWidget {
  final ProductItem product;
  final int qty;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.qty,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.marginSmall),
      padding: EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.paddingM),
        border: Border.all(color: Colors.black12),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE
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

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.type?.name ?? ''} | ${product.code}",
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
                    color: AppColors.lightTextPrimary,
                  ),
                ),

                SizedBox(height: AppSpacing.marginXS),

                Text(
                  "${product.unitPrice} ៛",
                  style: TextStyle(
                    fontSize: AppFontSize.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.marginMedium),

          // QUANTITY CONTROL (Same as Ordering)
          Row(
            children: [
              _circleBtn(Icons.remove, onDecrease),

              SizedBox(width: AppSpacing.marginSmall),

              Text(
                qty.toString(),
                style: TextStyle(
                  fontSize: AppFontSize.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: AppSpacing.marginSmall),

              _circleBtn(Icons.add, onIncrease),
            ],
          ),

          SizedBox(width: AppSpacing.marginSmall),

          // DELETE
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.delete,
              size: AppWidgetSize.iconMedium,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
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
