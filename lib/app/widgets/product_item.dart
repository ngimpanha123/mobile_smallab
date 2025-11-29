// product_item_widget.dart
import 'package:flutter/material.dart';
import 'package:mobile_eshop/app/config/app_config.dart';
import 'package:mobile_eshop/app/data/models/cashier_product_model.dart';

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
    // Use AppConfig.getImageUrl to get a proper HTTP URL
    final imageUrl = AppConfig.getImageUrl(product.image);

    print("🖼️ Image URL: $imageUrl"); // debug

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 60,
            child: (product.image == null || product.image!.isEmpty)
                ? Icon(Icons.image_not_supported, color: Colors.grey.shade400, size: 40)
                : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("❌ Image failed: $imageUrl");
                return Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40);
              },
            ),
          ),
        ),
        title: Text(
          product.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${product.unitPrice ?? 0} ៛",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
