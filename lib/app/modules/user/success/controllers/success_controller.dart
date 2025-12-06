import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/providers/cashier_provider.dart';

class SuccessController extends GetxController {
  final provider = Get.find<CashierProvider>();

  // ---------------------------------------------------------------------------
  // DOWNLOAD PDF (receipt number)
  // ---------------------------------------------------------------------------
  Future<String?> downloadInvoicePdf(String receiptNumber) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final base64Data = await provider.getInvoiceBase64(receiptNumber);

      Get.back(); // Close loading

      if (base64Data == null) {
        Get.snackbar("Error", "Invoice not found");
        return null;
      }

      final bytes = base64Decode(base64Data);

      final filePath =
          "/storage/emulated/0/Download/invoice_$receiptNumber.pdf";

      final file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      print("❌ Download Error: $e");
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // SHARE PDF
  // ---------------------------------------------------------------------------
  Future<void> sharePdf(String receiptNumber) async {
    final path = await downloadInvoicePdf(receiptNumber);
    if (path != null) {
      await Share.shareXFiles([XFile(path)], text: "Receipt Invoice");
    }
  }
}
