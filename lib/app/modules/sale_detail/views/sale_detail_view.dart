import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_eshop/app/constants/app_color.dart';
import '../controllers/sale_detail_controller.dart';
import '../widgets/sale_detail_item.dart';

class SaleDetailView extends GetView<SaleDetailController> {
  const SaleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales information"),
        backgroundColor: AppColors.surfaceColor,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final sale = controller.sale.value;
        if (sale == null) return const SizedBox();

        return Column(
          children: [
            // TOP TOTAL SECTION
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${sale.totalPrice} ៛",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sale.orderedAt ?? "",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const Divider(),

            // PRODUCT DETAILS
            Expanded(
              child: ListView.builder(
                itemCount: sale.details?.length ?? 0,
                itemBuilder: (_, i) {
                  return SaleDetailItem(
                    detail: sale.details![i],
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
