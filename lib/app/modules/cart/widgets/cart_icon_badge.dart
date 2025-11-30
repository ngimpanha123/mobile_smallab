import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_widget_size.dart';
import '../controllers/cart_controller.dart';


class CartIconWithBadge extends StatelessWidget {
  const CartIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      final count = cart.items.length;

      return GestureDetector(
        onTap: () {
          if (Get.currentRoute != "/cart") {
            Get.toNamed("/cart");
          }
        },

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cart Icon
            Icon(
              Icons.shopping_cart_outlined,
              size: AppWidgetSize.iconLarge,
              color: Theme.of(context).colorScheme.onBackground,
            ),

            // Badge
            if (count > 0)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
