import 'package:flutter/material.dart';
import '../../../config/app_config.dart';
import '../../../data/models/cashier_sale_model.dart';

class SaleDetailItem extends StatelessWidget {
  final SaleDetail detail;

  const SaleDetailItem({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final product = detail.product;

    return ListTile(
      leading: Image.network(
        AppConfig.getImageUrl(product?.image ?? ""),
        width: 45,
        fit: BoxFit.cover,
      ),
      title: Text(product?.name ?? ""),
      subtitle: Text("${product?.code}"),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("${detail.unitPrice} ៛"),
          Text("x${detail.qty}"),
        ],
      ),
    );
  }
}
