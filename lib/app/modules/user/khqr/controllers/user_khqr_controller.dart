// import 'dart:async';
// import 'package:get/get.dart';
// import '../../../../data/repositories/khqr_repository.dart';
// import '../../../../data/models/khqr_model.dart';
// import '../../../../routes/app_routes.dart';
//
// class KhqrController extends GetxController {
//   final repo = Get.find<KhqrRepository>();
//
//   late KhqrGenerateResult result;
//   late Map<String, int> cart;
//
//   var loading = true.obs;
//   Timer? timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // ✅ NOW THIS MATCHES WHAT YOU SEND
//     final args = Get.arguments as Map<String, dynamic>;
//     result = args["result"] as KhqrGenerateResult;
//     cart = args["cart"] as Map<String, int>;
//
//     loading(false);
//     _startConfirmLoop();
//   }
//
//   void _startConfirmLoop() {
//     timer = Timer.periodic(const Duration(seconds: 3), (_) async {
//       try {
//         final paid = await repo.confirmKhqr(result.md5, cart);
//
//         if (paid) {
//           timer?.cancel();
//           Get.offAllNamed(Routes.HOME, arguments: result);
//         }
//       } catch (_) {}
//     });
//   }
//
//   @override
//   void onClose() {
//     timer?.cancel();
//     super.onClose();
//   }
// }



import 'dart:async';
import 'package:get/get.dart';
import '../../../../data/repositories/khqr_repository.dart';
import '../../../../data/models/khqr_model.dart';
import '../../../../routes/app_routes.dart';
import '../../cart/controllers/cart_controller.dart';

class KhqrController extends GetxController {
  final repo = Get.find<KhqrRepository>();

  late KhqrGenerateResult result;
  late Map<String, int> cart;

  var loading = true.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    result = args["result"];
    cart = Map<String, int>.from(args["cart"]);

    loading(false);
    _startConfirmLoop();
  }

  void _startConfirmLoop() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final paid = await repo.confirmKhqr(result.md5, cart);

        if (paid) {
          timer?.cancel();

          // ✅ CLEAR CART AFTER SUCCESS
          final cartCtrl = Get.find<CartController>();
          cartCtrl.clearCart();

          // ✅ RETURN TO HOME (SAFE)
          Get.offAllNamed(Routes.HOME);
        }
      } catch (_) {}
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
