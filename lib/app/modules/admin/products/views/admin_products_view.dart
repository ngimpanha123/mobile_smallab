import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_color.dart';
import '../../../../data/models/admin/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/product_card_widget.dart';
import '../controllers/admin_products_controller.dart';

class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Product'),
              Tab(text: 'Type'),
            ],
          ),
        ),
        floatingActionButton: _fab(),
        body: const TabBarView(
          children: [
            _ProductsTab(),
            _TypesTab(),
          ],
        ),
      ),
    );
  }

  // ================= FAB =================
  Widget _fab() {
    return Builder(
      builder: (context) {
        final tabController = DefaultTabController.of(context);

        return FloatingActionButton(
          onPressed: () {
            if (tabController.index == 0) {
              Get.toNamed(Routes.ADMIN_PRODUCT_CREATE);
            } else {
              Get.toNamed(Routes.ADMIN_PRODUCT_TYPE_CREATE);
            }
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}

//////////////////////////////////////////////////////////////
// PRODUCTS TAB
//////////////////////////////////////////////////////////////

class _ProductsTab extends GetView<AdminProductsController> {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _categoryChips(),
        const Divider(height: 1),
        Expanded(child: _productList()),
      ],
    );
  }

  Widget _categoryChips() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _chip(
              title: 'All',
              selected: controller.selectedCategoryId.value == null,
              onTap: () => controller.selectCategory(null),
            ),
            ...controller.productTypes.map(
                  (type) => _chip(
                title: type.name ?? '',
                selected:
                controller.selectedCategoryId.value == type.id,
                onTap: () => controller.selectCategory(type.id),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _chip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(title),
        selected: selected,
        selectedColor: AppColors.primary,
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _productList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.products.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final ProductData product = controller.products[index];
          return InkWell(
            onTap: () => Get.toNamed(
              Routes.ADMIN_PRODUCT_EDIT,
              arguments: product,
            ),
            child: ProductCardWidget(product: product),
          );
        },
      );
    });
  }
}

//////////////////////////////////////////////////////////////
// TYPES TAB
//////////////////////////////////////////////////////////////

class _TypesTab extends GetView<AdminProductsController> {
  const _TypesTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.productTypes.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final type = controller.productTypes[index];

          return ListTile(
            leading: const Icon(Icons.category),
            title: Text(type.name ?? ''),
            trailing: Text(type.nOfProducts ?? '0'),
            onTap: () => Get.toNamed(
              Routes.ADMIN_PRODUCT_TYPE_EDIT,
              arguments: type,
            ),
          );
        },
      );
    });
  }
}
