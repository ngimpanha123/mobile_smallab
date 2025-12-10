import 'dart:async';
import 'package:get/get.dart';
import '../../../../data/repositories/khqr_repository.dart';
import '../../../../data/models/khqr_model.dart';

class KhqrController extends GetxController {
  final repo = Get.find<KhqrRepository>();

  late KhqrGenerateResult result;
  late Map<String, int> cart;

  var loading = true.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();

    // ✅ NOW THIS MATCHES WHAT YOU SEND
    final args = Get.arguments as Map<String, dynamic>;
    result = args["result"] as KhqrGenerateResult;
    cart = args["cart"] as Map<String, int>;

    loading(false);
    _startConfirmLoop();
  }

  void _startConfirmLoop() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final paid = await repo.confirmKhqr(result.md5, cart);

        if (paid) {
          timer?.cancel();
          Get.offAllNamed("/user/khqr-success", arguments: result);
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
