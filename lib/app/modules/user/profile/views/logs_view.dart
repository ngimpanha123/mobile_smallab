import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_spacing.dart';
import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("Activity Logs"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final logs = controller.filteredLogs;

        return Column(
          children: [
            _buildFilters(),
            Expanded(
              child: logs.isEmpty
                  ? const Center(child: Text("No activity found"))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (_, i) => _logCard(logs[i]),
              ),
            ),
            _buildPagination(),
          ],
        );
      }),
    );
  }

  // ----------------------------------------------------
  // FILTER UI (Action + Platform)
  // ----------------------------------------------------
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // Action Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: controller.selectedAction.value,
              items: ["All", "login", "update", "delete"]
                  .map((v) => DropdownMenuItem(
                value: v,
                child: Text(v.capitalize!),
              ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: "Action",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => controller.selectedAction.value = v!,
            ),
          ),
          const SizedBox(width: 12),

          // Platform Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: controller.selectedPlatform.value,
              items: ["All", "Mobile", "Web"]
                  .map((v) => DropdownMenuItem(
                value: v,
                child: Text(v),
              ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: "Platform",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => controller.selectedPlatform.value = v!,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // LOG CARD UI
  // ----------------------------------------------------
  Widget _logCard(log) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.marginSmall),
      padding: EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          _iconFromAction(log.action),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.action?.toUpperCase() ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  log.details ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${log.platform}  •  ${log.timestamp}",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pick icon based on action type
  Widget _iconFromAction(String? action) {
    IconData icon;
    Color color;

    switch (action) {
      case "login":
        icon = Icons.login;
        color = Colors.blue;
        break;
      case "update":
        icon = Icons.edit;
        color = Colors.orange;
        break;
      case "delete":
        icon = Icons.delete;
        color = Colors.red;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, size: 22, color: color),
    );
  }

  // ----------------------------------------------------
  // PAGINATION UI
  // ----------------------------------------------------
  Widget _buildPagination() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Prev Button
            IconButton(
              onPressed: controller.page.value > 1
                  ? () => controller.prevPage()
                  : null,
              icon: const Icon(Icons.arrow_back_ios),
            ),

            // Page Indicator
            Text(
              "Page ${controller.page.value} of ${controller.totalPage.value}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            // Next Button
            IconButton(
              onPressed: controller.page.value < controller.totalPage.value
                  ? () => controller.nextPage()
                  : null,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      );
    });
  }
}
