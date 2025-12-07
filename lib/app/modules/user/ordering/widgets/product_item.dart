import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../data/models/cashier_product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class ModernProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;

  const ModernProductCard({
    super.key,
    required this.product,
    this.onAdd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final qty = cart.getQuantity(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AREA (Stack so we can float the add button and badges)
            Stack(
              children: [
                // pale panel that holds image
                Container(
                  color: Colors.grey.shade100,
                  child: AspectRatio(
                    aspectRatio: 1.2, // large visual area for image
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          AppConfig.getImageUrl(product.image),
                          fit: BoxFit.cover, // fills area nicely
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                ),

                // Optional: type badge top-left
                if ((product.type?.name ?? '').isNotEmpty)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.type!.name!,
                        style: TextStyle(
                          fontSize: AppFontSize.bodySmall - 1,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ),

                // Floating add button bottom-right (overlaps image)
                Positioned(
                  right: 12,
                  bottom: -18, // negative to float half over image & half over body
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 6,
                    color: Colors.transparent,
                    child: qty == 0
                        ? GestureDetector(
                      onTap: () {
                        // default behavior
                        if (onAdd != null) onAdd!();
                        else cart.addItem(product);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.18),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    )
                        : _qtyFloating(qty, cart),
                  ),
                ),
              ],
            ),

            // Body area (name, price, short description)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.paddingM,
                AppSpacing.paddingS + 18, // extra top spacing so floating button doesn't overlap text
                AppSpacing.paddingM,
                AppSpacing.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.titleSmall,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginXS),

                  // Price row
                  Text(
                    _formatPrice(),
                    style: const TextStyle(
                      fontSize: 48,  // <- MAKE THIS AS BIG AS YOU WANT
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginSmall),

                  // Short description (using code/type if no full description)
                  Text(
                    _shortDescription(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.bodySmall,
                      color: AppColors.lightTextSecondary,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // small floating qty controls used when qty > 0
  Widget _qtyFloating(int qty, CartController cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => cart.decreaseItem(product),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
              child: const Icon(Icons.remove, size: 14),
            ),
          ),
          SizedBox(width: 6),
          Text(qty.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 6),
          GestureDetector(
            onTap: () => cart.addItem(product),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
              child: const Icon(Icons.add, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice() {
    final price = product.unitPrice ?? 0;
    return '\$${price.toString()}';
  }

  String _shortDescription() {
    final code = product.code ?? '';
    final type = product.type?.name ?? '';
    final parts = <String>[];
    if (code.isNotEmpty) parts.add(code);
    if (type.isNotEmpty) parts.add(type);
    return parts.join(' • ');
  }
}
