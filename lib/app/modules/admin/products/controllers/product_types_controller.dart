import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/admin/product_type_model.dart';
import '../../../../data/providers/admin_provider.dart';

class ProductTypesController extends GetxController {
  final AdminProvider provider = Get.find();
  final ImagePicker picker = ImagePicker();

  var isLoading = false.obs;
  var types = <ProductTypeData>[].obs;
  var pickedImageBase64 = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    isLoading.value = true;

    final Response res = await provider.getProductTypes();
    final parsed = AdminProductTypeResponse.fromJson(res.data);
    types.assignAll(parsed.data ?? []);

    isLoading.value = false;
  }

  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await File(file.path).readAsBytes();
      pickedImageBase64.value =
      'data:image/png;base64,${base64Encode(bytes)}';
    }
  }

  void setEditImage(String? image) {
    pickedImageBase64.value = image;
  }

  void clearImage() {
    pickedImageBase64.value = null;
  }

  Future<void> createType(String name) async {
    await provider.createProductType(
      name: name,
      imageBase64: pickedImageBase64.value,
    );
    clearImage();
    fetchTypes();
  }

  Future<void> updateType({
    required int id,
    required String name,
  }) async {
    await provider.updateProductType(
      typeId: id,
      name: name,
      imageBase64: pickedImageBase64.value,
    );
    clearImage();
    fetchTypes();
  }

  Future<void> deleteType(int id) async {
    await provider.deleteProductType(typeId: id);
    fetchTypes();
  }
}
