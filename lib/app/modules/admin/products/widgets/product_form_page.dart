import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../data/models/admin/product_model.dart';
import '../controllers/admin_products_controller.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final AdminProductsController controller;

  late final TextEditingController nameCtrl;
  late final TextEditingController codeCtrl;
  late final TextEditingController priceCtrl;

  ProductData? product;
  int? typeId;

  bool get isEdit => product != null;

  @override
  void initState() {
    super.initState();

    controller = Get.find<AdminProductsController>();

    // ✅ Read product from arguments (null = create)
    product = Get.arguments as ProductData?;

    // ✅ Preload image
    if (product != null) {
      controller.setEditImage(product!.image);
    } else {
      controller.clearImage();
    }

    nameCtrl = TextEditingController(text: product?.name);
    codeCtrl = TextEditingController(text: product?.code);
    priceCtrl =
        TextEditingController(text: product?.unitPrice?.toString());

    typeId = product?.type?.id;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    priceCtrl.dispose();
    controller.clearImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Update Product' : 'Create Product'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _imagePicker(),
              const SizedBox(height: 24),
              _formFields(),
              const SizedBox(height: 24),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= IMAGE PICKER =================
  Widget _imagePicker() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Obx(() {
        final String? image = controller.pickedImageBase64.value;

        ImageProvider? imageProvider;

        if (image != null && image.isNotEmpty) {
          if (image.startsWith('data:image')) {
            imageProvider = MemoryImage(
              base64Decode(image.split(',').last),
            );
          } else {
            imageProvider = NetworkImage(
              AppConfig.getImageUrl(image),
            );
          }
        }

        return CircleAvatar(
          radius: 120,
          backgroundColor: AppColors.primary.withOpacity(.1),
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.camera_alt, size: 28)
              : null,
        );
      }),
    );
  }

  // ================= FORM =================
  Widget _formFields() {
    return Column(
      children: [
        TextField(
          controller: codeCtrl,
          decoration: const InputDecoration(labelText: 'Code'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          value: typeId,
          decoration: const InputDecoration(labelText: 'Category'),
          items: controller.productTypes
              .map(
                (e) => DropdownMenuItem<int>(
              value: e.id,
              child: Text(e.name ?? ''),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() => typeId = v),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Price'),
        ),
      ],
    );
  }

  // ================= SAVE =================
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (isEdit) {
            await controller.updateProduct(
              productId: product!.id!,
              name: nameCtrl.text,
              code: codeCtrl.text,
              price: priceCtrl.text,
              typeId: typeId.toString(),
            );
          } else {
            await controller.createProduct(
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
    );
  }

  // ================= DELETE =================
  void _deleteProduct() async {
    await controller.deleteProduct(product!.id!);
    Get.back();
  }
}
