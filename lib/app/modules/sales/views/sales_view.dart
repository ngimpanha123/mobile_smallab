import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/sale_item.dart';
import '../controllers/sales_controller.dart'; // adjust path if different

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Total today header
          Obx(() {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today Total',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.totalToday.value} ៛',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          // List of sales (must be wrapped in Expanded)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.sales.isEmpty) {
                return const Center(
                  child: Text('No sales found'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: controller.sales.length,
                itemBuilder: (_, i) {
                  final sale = controller.sales[i];
                  return SaleItemWidget(
                    sale: sale,
                    onTap: () => controller.openSaleDetail(sale.id!),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
