import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_eshop/app/constants/app_color.dart';
import '../../user/cart/views/cart_view.dart';
import '../../user/ordering/views/ordering_view.dart';
import '../../user/profile/views/profile_view.dart';
import '../../user/sales/views/sales_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  final pages = const [
    OrderingView(),
    SalesView(),
    ProfileView(),

  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        body: pages[controller.tabIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale),
              label: "Ordering",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Sales",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),

          ],
        ),
      ),
    );
  }
}
