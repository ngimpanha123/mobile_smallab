import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KhqrExpiredView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 120),
            SizedBox(height: 20),
            Text("QR Code Expired",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text("Back to Cart"),
            )
          ],
        ),
      ),
    );
  }
}
