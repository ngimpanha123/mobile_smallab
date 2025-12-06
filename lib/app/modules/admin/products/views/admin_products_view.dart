import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_products_controller.dart';

class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminProductsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminProductsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
