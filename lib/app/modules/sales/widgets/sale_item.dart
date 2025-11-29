import 'package:flutter/material.dart';
import '../../../data/models/cashier_sale_model.dart';

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
    return ListTile(
      onTap: onTap,
      title: Text(
        "#${sale.receiptNumber}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        sale.orderedAt ?? "",
        style: TextStyle(color: Colors.grey.shade600),
      ),
      trailing: Text(
        "${sale.totalPrice} ៛",
        style: const TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
