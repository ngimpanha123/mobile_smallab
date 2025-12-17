import 'package:flutter/material.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../data/models/admin/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductData product;

  const ProductCardWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
      child: Row(
        children: [
          _image(),
          SizedBox(width: AppSpacing.paddingM),
          Expanded(child: _info()),
        ],
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        color: AppColors.lightSurface,
        child: product.image != null && product.image!.isNotEmpty
            ? Image.network(
          product.image!,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.image_not_supported),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${product.type?.name ?? ''} | ${product.code ?? ''}',
          style: TextStyle(
            fontSize: AppFontSize.bodySmall,
            color: AppColors.greyColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.name ?? '',
          style: TextStyle(
            fontSize: AppFontSize.bodyLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${product.unitPrice ?? 0} ៛',
          style: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
