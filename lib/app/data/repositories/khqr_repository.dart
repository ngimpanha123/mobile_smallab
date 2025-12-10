import 'package:get/get.dart';
import '../providers/cashier_provider.dart';
import '../models/khqr_model.dart';

class KhqrRepository {
  final CashierProvider provider = Get.find<CashierProvider>();

  Map<String, int> _convertCart(Map<dynamic, dynamic> cart) {
    final Map<String, int> result = {};
    cart.forEach((key, value) {
      result[key.toString()] = value is int
          ? value
          : int.tryParse(value.toString()) ?? 0;
    });
    return result;
  }

  /// ✅ Generate KHQR
  Future<KhqrGenerateResult> generateKhqr(Map cart) async {
    final safeCart = _convertCart(cart);
    final res = await provider.generateKhqr(safeCart);
    return KhqrGenerateResult.fromJson(res);
  }

  /// ✅ Confirm KHQR
  Future<bool> confirmKhqr(String md5, Map cart) async {
    final safeCart = _convertCart(cart);

    final res = await provider.confirmKhqr(
      md5: md5,
      cart: safeCart,
    );

    return res["status"] == "success" &&
        res["order"] != null &&
        res["order"]["status"] == "paid";
  }
}
