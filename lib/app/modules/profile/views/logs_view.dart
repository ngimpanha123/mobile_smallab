import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ប្រតិបត្តិការ Logs")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.logs.length,
          itemBuilder: (_, i) {
            final log = controller.logs[i];
            return ListTile(
              title: Text(log.action ?? ""),
              subtitle: Text("${log.platform} • ${log.timestamp}"),
            );
          },
        );
      }),
    );
  }
}
