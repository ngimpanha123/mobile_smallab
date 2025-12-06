import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/cashier_sale_model.dart';

class SaleItemWidget extends StatelessWidget {
  final SaleData sale;
  final VoidCallback onTap;

  const SaleItemWidget({
    super.key,
    required this.sale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Icon(Icons.list_alt_rounded,
                size: AppWidgetSize.iconMedium,
                color: AppColors.primary),

            SizedBox(width: AppSpacing.marginMedium),

            // Receipt Number & Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${sale.receiptNumber}",
                    style: TextStyle(
                      fontSize: AppFontSize.titleSmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.marginXS),
                  Text(
                    sale.orderedAt ?? "",
                    style: TextStyle(
                      fontSize: AppFontSize.bodySmall,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              "${sale.totalPrice} ៛",
              style: TextStyle(
                fontSize: AppFontSize.bodyLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),

            SizedBox(width: AppSpacing.marginSmall),

            // Cashier avatar
            CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                AppConfig.getImageUrl(sale.cashier?.avatar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
