// lib/app/modules/user/sale_detail/controllers/sale_detail_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/models/cashier_sale_model.dart';
import '../../../../data/providers/cashier_provider.dart';

class SaleDetailController extends GetxController {
  final cashierProvider = Get.find<CashierProvider>();

  var sale = Rxn<SaleData>();
  var isLoading = false.obs;
  var isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSaleDetail();
  }

  // -------------------------------------------------------------
  // LOAD SALE DETAIL
  // -------------------------------------------------------------
  Future<void> loadSaleDetail() async {
    try {
      isLoading(true);
      final int saleId = Get.arguments;
      final response = await cashierProvider.getSaleView(saleId);
      sale(response.data);
    } catch (e) {
      print("❌ Sale Detail Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // -------------------------------------------------------------
  // DOWNLOAD PDF (base64 → PDF file)
  // -------------------------------------------------------------
  Future<String?> downloadInvoicePdf() async {
    try {
      final data = sale.value;
      if (data == null) return null;

      final receipt = data.receiptNumber;
      if (receipt == null) return null;

      isDownloading(true);

      final base64Data = await cashierProvider.getInvoiceBase64(receipt);
      if (base64Data == null) {
        Get.snackbar("Error", "Invoice not found");
        return null;
      }

      final bytes = base64Decode(base64Data);

      // Save PDF into Download folder (Android)
      const downloadPath = "/storage/emulated/0/Download";
      final dir = Directory(downloadPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final filePath = "$downloadPath/invoice_$receipt.pdf";
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      Get.snackbar("Success", "Saved to Download/invoice_$receipt.pdf",
          snackPosition: SnackPosition.BOTTOM);

      return filePath;

    } catch (e) {
      print("❌ PDF Download Error: $e");
      Get.snackbar("Error", "Failed to save invoice.");
      return null;
    } finally {
      isDownloading(false);
    }
  }

  // -------------------------------------------------------------
  // SHARE PDF
  // -------------------------------------------------------------
  Future<void> shareInvoice() async {
    final path = await downloadInvoicePdf();
    if (path != null) {
      await Share.shareXFiles(
        [XFile(path)],
        text: "Invoice PDF",
      );
    }
  }
}
