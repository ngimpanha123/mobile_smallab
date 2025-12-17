import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../data/models/admin/product_type_model.dart';
import '../controllers/product_types_controller.dart';

class ProductTypeFormPage extends StatefulWidget {
  const ProductTypeFormPage({super.key});

  @override
  State<ProductTypeFormPage> createState() => _ProductTypeFormPageState();
}

class _ProductTypeFormPageState extends State<ProductTypeFormPage> {
  late final ProductTypesController controller;
  late final TextEditingController nameCtrl;

  ProductTypeData? type;
  bool get isEdit => type != null;

  @override
  void initState() {
    super.initState();

    // ✅ Controller always exists because route has binding
    controller = Get.find<ProductTypesController>();

    // ✅ Read arguments (EDIT = has data, CREATE = null)
    type = Get.arguments as ProductTypeData?;

    if (type != null) {
      controller.setEditImage(type!.image);
    } else {
      controller.clearImage();
    }

    nameCtrl = TextEditingController(text: type?.name);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    controller.clearImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Update Category' : 'Create Category'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _delete,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _imagePicker(),
            const SizedBox(height: 24),
            TextField(
              controller: nameCtrl,
              decoration:
              const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 24),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  // ================= IMAGE =================
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
              ? const Icon(Icons.camera_alt)
              : null,
        );
      }),
    );
  }

  // ================= SAVE =================
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (isEdit) {
            await controller.updateType(
              id: type!.id!,
              name: nameCtrl.text,
            );
          } else {
            await controller.createType(nameCtrl.text);
          }
          Get.back();
        },
        child: const Text('Save'),
      ),
    );
  }

  // ================= DELETE =================
  void _delete() async {
    await controller.deleteType(type!.id!);
    Get.back();
  }
}
