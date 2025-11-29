import 'package:flutter/material.dart';
import '../../../config/app_config.dart';
import '../../../data/models/cashier_product_model.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            AppConfig.getImageUrl(product.image),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product.name ?? ""),
        subtitle: Text("${product.unitPrice ?? 0} ៛"),
        trailing: IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle, color: Colors.blue),
        ),
      ),
    );
  }
}
