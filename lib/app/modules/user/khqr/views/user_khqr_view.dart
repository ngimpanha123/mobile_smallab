// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_flutter/qr_flutter.dart'; // ✅ USE THIS INSTEAD
// import '../controllers/user_khqr_controller.dart';
//
// class KhqrView extends GetView<KhqrController> {
//   const KhqrView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bakong KHQR Payment"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.loading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // ✅ SAFE QR RENDER
//                 QrImageView(
//                   data: controller.result.qr, // ✅ RAW KHQR STRING
//                   size: 300,
//                   backgroundColor: Colors.white,
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Text(
//                   "Amount: ${controller.result.amount} ៛",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 const Text("Scan with Bakong App"),
//
//                 const SizedBox(height: 30),
//
//                 const CircularProgressIndicator(),
//
//                 const SizedBox(height: 10),
//
//                 const Text("Waiting for payment confirmation..."),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/user_khqr_controller.dart';

class KhqrView extends GetView<KhqrController> {
  const KhqrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bakong KHQR Payment"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: controller.result.qr,
                  size: 300,
                  backgroundColor: Colors.white,
                ),

                const SizedBox(height: 20),

                Text(
                  "Amount: ${controller.result.amount} ៛",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text("Scan with Bakong App"),

                const SizedBox(height: 30),

                const CircularProgressIndicator(),

                const SizedBox(height: 10),

                const Text("Waiting for payment confirmation..."),
              ],
            ),
          ),
        );
      }),
    );
  }
}
