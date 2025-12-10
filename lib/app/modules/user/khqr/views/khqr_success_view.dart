import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_color.dart';

class KhqrSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 120),
            SizedBox(height: 20),
            Text("Payment Successful!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10),
            Text("Receipt: ${order['receiptNumber']}"),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAllNamed("/user/success", arguments: order),
              child: Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}
