import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/cashier_product_model.dart';
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
    final qty = cart.getQuantity(product.id);

    return Column(
      mainAxisSize: MainAxisSize.max,          // 🔥 Prevent overflow
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // IMAGE — Flexible height so card fits inside grid cell
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

        // PRODUCT CODE
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

        // PRODUCT NAME
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

        // PRICE + ADD BUTTON
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
                ? GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.all(AppSpacing.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            )
                : Row(
              children: [
                _qtyBtn(Icons.remove, () => cart.decreaseItem(product)),
                SizedBox(width: 6),
                Text(
                  qty.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 6),
                _qtyBtn(Icons.add, () => cart.addItem(product)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingXS),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}


// class ProductItemWidget extends StatelessWidget {
//   final ProductItem product;
//   final VoidCallback onAdd;
//
//   const ProductItemWidget({
//     super.key,
//     required this.product,
//     required this.onAdd,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Get.find<CartController>();
//     final qty = cart.getQuantity(product.id);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           // IMAGE — FIX: Big, top, full-width
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//             child: Image.network(
//               AppConfig.getImageUrl(product.image),
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.all(AppSpacing.paddingSM),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // CODE
//                 Text(
//                   product.code ?? "",
//                   style: TextStyle(
//                     fontSize: AppFontSize.titleSmall,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 SizedBox(height: 4),
//
//                 // NAME
//                 Text(
//                   product.name ?? "",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: AppFontSize.bodySmall,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//
//                 // PRICE + ADD button horizontally aligned
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//
//                     Text(
//                       "\$ ${product.unitPrice}",
//                       style: TextStyle(
//                         fontSize: AppFontSize.titleMedium,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primary,
//                       ),
//                     ),
//
//                     qty == 0
//                         ? _addButton(onAdd)
//                         : _qtyController(cart, product, qty),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _addButton(VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: AppColors.primary,
//         ),
//         child: const Icon(Icons.add, size: 18, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _qtyController(CartController cart, ProductItem product, int qty) {
//     return Row(
//       children: [
//         _qtyBtn(Icons.remove, () => cart.decreaseItem(product)),
//         SizedBox(width: 6),
//         Text(
//           qty.toString(),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(width: 6),
//         _qtyBtn(Icons.add, () => cart.addItem(product)),
//       ],
//     );
//   }
//
//   Widget _qtyBtn(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: AppColors.primary,
//         ),
//         child: Icon(icon, size: 18, color: Colors.white),
//       ),
//     );
//   }
// }