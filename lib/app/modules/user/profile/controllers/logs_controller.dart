import 'package:get/get.dart';
import '../../../../data/models/cashier_log_model.dart';
import '../../../../data/providers/profile_provider.dart';

class LogsController extends GetxController {
  final provider = Get.find<ProfileProvider>();

  var logs = <LogData>[].obs;
  var isLoading = false.obs;

  // Pagination
  var page = 1.obs;
  var totalPage = 1.obs;

  // Filters
  var selectedAction = "All".obs;
  var selectedPlatform = "All".obs;

  @override
  void onInit() {
    super.onInit();
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      isLoading(true);

      final res = await provider.getLogs(page: page.value);

      logs.assignAll(res.data ?? []);
      totalPage.value = res.pagination?.totalPage ?? 1;

    } catch (e) {
      print("❌ Logs Load Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Apply filters
  List<LogData> get filteredLogs {
    return logs.where((log) {
      final matchAction =
          selectedAction.value == "All" || log.action == selectedAction.value;
      final matchPlatform =
          selectedPlatform.value == "All" || log.platform == selectedPlatform.value;

      return matchAction && matchPlatform;
    }).toList();
  }

  void prevPage() {
    if (page.value > 1) {
      page.value--;
      loadLogs();
    }
  }

  void nextPage() {
    if (page.value < totalPage.value) {
      page.value++;
      loadLogs();
    }
  }
}
