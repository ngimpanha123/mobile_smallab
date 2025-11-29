import 'package:get/get.dart';
import '../../../data/providers/profile_provider.dart';
import '../../../data/models/cashier_log_model.dart';

class LogsController extends GetxController {
  final provider = Get.find<ProfileProvider>();

  var logs = <LogData>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      isLoading(true);
      final response = await provider.getLogs();
      logs.assignAll(response.data ?? []);
    } catch (e) {
      print("❌ Logs Load Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
