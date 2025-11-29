import 'package:flutter/material.dart';
import 'package:mobile_eshop/app/config/app_config.dart';
import 'package:mobile_eshop/app/data/models/cashier_product_model.dart';

class CartItemWidget extends StatelessWidget {
  final ProductItem product;
  final int qty;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.qty,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          AppConfig.getImageUrl(product.image),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.error),
        ),
      ),
      title: Text(product.name ?? ""),
      subtitle: Text("${product.unitPrice} ៛"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove)),
          Text(qty.toString()),
          IconButton(onPressed: onIncrease, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
