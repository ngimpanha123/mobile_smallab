import 'package:get/get.dart';
import '../../../../data/providers/cashier_provider.dart';
import '../../../../data/models/cashier_notification_model.dart';

class NotificationController extends GetxController {
  final provider = Get.find<CashierProvider>();

  var notifications = <CashierNotification>[].obs;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      loading(true);
      final data = await provider.getNotifications();
      notifications.assignAll(data);
    } finally {
      loading(false);
    }
  }

  Future<void> deleteItem(int id) async {
    final ok = await provider.deleteNotification(id);
    if (ok) {
      notifications.removeWhere((n) => n.id == id);
      Get.snackbar("Deleted", "Notification removed");
    }
  }
}
