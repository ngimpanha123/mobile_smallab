import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_color.dart';
import '../../admin/dashboard/views/admin_dashboard_view.dart';
import '../../admin/products/views/admin_products_view.dart';
import '../../admin/sales/views/admin_sales_view.dart';
import '../../admin/settings/views/admin_settings_view.dart';
import '../../admin/users/views/admin_users_view.dart';
import '../controllers/home_admin_controller.dart';


class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});

  final List<Widget> pages = const [
    DashboardView(),
    AdminSalesView(),
    AdminProductsView(),
    AdminUsersView(),
    AdminSettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        body: pages[controller.tabIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Sales",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: "Products",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Users",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf),
              label: "Setting",
            ),
          ],
        ),
      ),
    );
  }
}
