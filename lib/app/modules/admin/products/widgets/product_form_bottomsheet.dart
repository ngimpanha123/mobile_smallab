import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/admin/product_model.dart';
import '../controllers/admin_products_controller.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';

class ProductFormBottomSheet extends StatelessWidget {
  final ProductData? product;

  const ProductFormBottomSheet({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminProductsController>();

    // ================= PRELOAD IMAGE FOR EDIT =================
    if (product != null && controller.pickedImageBase64.value == null) {
      Future.microtask(() {
        controller.setEditImage(product!.image);
      });
    }

    final nameCtrl = TextEditingController(text: product?.name);
    final codeCtrl = TextEditingController(text: product?.code);
    final priceCtrl =
    TextEditingController(text: product?.unitPrice?.toString());

    int? typeId = product?.type?.id;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product == null ? 'Create Product' : 'Update Product',
                style: TextStyle(
                  fontSize: AppFontSize.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // ================= IMAGE =================
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  final base64 = controller.pickedImageBase64.value;

                  return CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(.1),
                    backgroundImage:
                    (base64 != null && base64.isNotEmpty)
                        ? MemoryImage(
                      base64Decode(base64.split(',').last),
                    )
                        : null,
                    child: (base64 == null || base64.isEmpty)
                        ? const Icon(Icons.camera_alt)
                        : null,
                  );
                }),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              DropdownButtonFormField<int>(
                value: typeId,
                decoration:
                const InputDecoration(labelText: 'Category'),
                items: controller.productTypes
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name ?? ''),
                  ),
                )
                    .toList(),
                onChanged: (v) => setState(() => typeId = v),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),

              const SizedBox(height: 16),

              // ================= SAVE =================
              ElevatedButton(
                onPressed: () async {
                  if (product == null) {
                    await controller.createProduct(
                      name: nameCtrl.text,
                      code: codeCtrl.text,
                      price: priceCtrl.text,
                      typeId: typeId.toString(),
                    );
                  } else {
                    await controller.updateProduct(
                      productId: product!.id!,
                      name: nameCtrl.text,
                      code: codeCtrl.text,
                      price: priceCtrl.text,
                      typeId: typeId.toString(),
                    );
                  }
                  Get.back();
                },
                child: const Text('Save'),
              ),

              // ================= DELETE =================
              if (product != null)
                TextButton(
                  onPressed: () async {
                    await controller.deleteProduct(product!.id!);
                    Get.back();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
