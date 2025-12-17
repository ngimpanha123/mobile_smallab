import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/product_types_controller.dart';

class ProductTypesView extends GetView<ProductTypesController> {
  const ProductTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ប្រភេទ'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ✅ USE NAMED ROUTE WITH BINDING
          Get.toNamed(Routes.ADMIN_PRODUCT_TYPE_CREATE);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.types.isEmpty) {
          return const Center(child: Text('No categories'));
        }

        return ListView.separated(
          itemCount: controller.types.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final type = controller.types[index];

            return ListTile(
              leading: const Icon(Icons.category),
              title: Text(type.name ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(type.nOfProducts ?? '0'),
                ],
              ),
              onTap: () {
                // ✅ PASS DATA VIA ARGUMENTS
                Get.toNamed(
                  Routes.ADMIN_PRODUCT_TYPE_EDIT,
                  arguments: type,
                );
              },
            );
          },
        );
      }),
    );
  }
}
