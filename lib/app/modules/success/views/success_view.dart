import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final receipt = Get.arguments;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "ជោគជ័យ",
              style: TextStyle(fontSize: 26, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 10),
            Text("Receipt #$receipt"),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.offAllNamed("/ordering"),
              child: const Text("បញ្ជាទិញថ្មី"),
            )
          ],
        ),
      ),
    );
  }
}
