import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_users_controller.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminUsersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminUsersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
