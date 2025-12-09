import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../config/app_config.dart';
import '../controllers/notification_controller.dart';

class NotificationBottomSheet {
  static void show() {
    final controller = Get.put(NotificationController());

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(AppSpacing.paddingL),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Obx(() {
          if (controller.loading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text("No notifications"),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.notifications.length,
                  itemBuilder: (_, i) {
                    final item = controller.notifications[i];
                    return Container(
                      padding: EdgeInsets.all(14),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: item.read == false
                            ? Colors.blue.withOpacity(.07)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              AppConfig.getImageUrl(item.cashier?.avatar),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Receipt #${item.receiptNumber}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${item.totalPrice}៛ • ${item.orderedAt}",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                controller.deleteItem(item.id ?? 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      isScrollControlled: true,
    );
  }
}
