import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/admin/product_model.dart';
import '../../../../data/models/admin/product_type_model.dart';
import '../../../../data/providers/admin_provider.dart';

class AdminProductsController extends GetxController {
  final AdminProvider provider = Get.find();
  final ImagePicker picker = ImagePicker();

  var isLoading = false.obs;

  /// Products
  var products = <ProductData>[].obs;
  List<ProductData> allProducts = [];

  /// Categories
  var productTypes = <ProductTypeData>[].obs;
  var selectedCategoryId = RxnInt();

  /// Image
  var pickedImageBase64 = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchProductTypes();
  }

  // ================= PRODUCTS =================
  Future<void> fetchProducts() async {
    isLoading.value = true;

    final Response res = await provider.getProducts(
      getAll: true,
      page: 1,
      limit: 1000,
    );

    final parsed = AdminProductResponse.fromJson(res.data);
    allProducts = parsed.data ?? [];
    applyCategoryFilter();

    isLoading.value = false;
  }

  void applyCategoryFilter() {
    if (selectedCategoryId.value == null) {
      products.assignAll(allProducts);
    } else {
      products.assignAll(
        allProducts.where(
              (p) => p.type?.id == selectedCategoryId.value,
        ),
      );
    }
  }

  void selectCategory(int? id) {
    selectedCategoryId.value = id;
    applyCategoryFilter();
  }

  // ================= IMAGE =================
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

  // ================= PRODUCT CRUD =================
  Future<void> createProduct({
    required String name,
    required String code,
    required String price,
    required String typeId,
  }) async {
    await provider.createProduct(
      name: name,
      code: code,
      unitPrice: price,
      typeId: typeId,
      imageBase64: pickedImageBase64.value,
    );
    clearImage();
    fetchProducts();
  }

  Future<void> updateProduct({
    required int productId,
    required String name,
    required String code,
    required String price,
    required String typeId,
  }) async {
    await provider.updateProduct(
      productId: productId,
      name: name,
      code: code,
      unitPrice: price,
      typeId: typeId,
      imageBase64: pickedImageBase64.value,
    );
    clearImage();
    fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await provider.deleteProduct(productId: id);
    clearImage();
    fetchProducts();
  }

  // ================= PRODUCT TYPES =================
  Future<void> fetchProductTypes() async {
    final Response res = await provider.getProductTypes();
    final parsed = AdminProductTypeResponse.fromJson(res.data);
    productTypes.assignAll(parsed.data ?? []);
  }
}
