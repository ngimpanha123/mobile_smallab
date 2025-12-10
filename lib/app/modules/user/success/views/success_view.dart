import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/cashier_order_model.dart';
import '../controllers/success_controller.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SuccessController>();
    final args = Get.arguments;

    // ---------------------------
    // CASE 1: Simple String
    // ---------------------------
    if (args is String) {
      return _buildSimpleSuccess(context, args);
    }

    // ---------------------------
    // CASE 2: When KHQR success returns raw JSON
    // Example: { receipt_number: "...", total: 2000, items: [...], ... }
    // ---------------------------
    if (args is Map<String, dynamic>) {
      return _buildKhqrSuccess(context, args, controller);
    }

    // ---------------------------
    // CASE 3: OrderData Model
    // ---------------------------
    if (args is OrderData) {
      return _buildOrderSuccess(context, args, controller);
    }

    return Scaffold(
      body: Center(child: Text("Invalid success payload")),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD SUCCESS FOR NORMAL CHECKOUT (OrderData Model)
  // ---------------------------------------------------------------------------
  Widget _buildOrderSuccess(
      BuildContext context, OrderData order, SuccessController controller) {
    final receiptNumber = order.receiptNumber ?? "";
    final total = order.totalPrice ?? 0;
    final cashier = order.cashier?.name ?? "Unknown";
    final orderedAt = order.orderedAt ?? "";
    final details = order.details ?? [];

    return _successLayout(
      context: context,
      receiptNumber: receiptNumber,
      total: total,
      cashier: cashier,
      orderedAt: orderedAt,
      productDetails: details.map((e) {
        return {
          "name": e.product?.name ?? "",
          "qty": e.qty ?? 0,
          "unitPrice": e.unitPrice ?? 0,
        };
      }).toList(),
      controller: controller,
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD SUCCESS FOR KHQR CONFIRM RETURN JSON
  // ---------------------------------------------------------------------------
  Widget _buildKhqrSuccess(
      BuildContext context, Map<String, dynamic> json, SuccessController controller) {
    final receipt = json["receipt_number"]?.toString() ?? json["receipt"] ?? "";
    final total = json["total"] ?? json["amount"] ?? 0;
    final cashier = json["cashier_name"] ?? "Cashier";
    final orderedAt = json["ordered_at"] ?? json["created_at"] ?? "";
    final items = (json["items"] ?? json["details"] ?? []) as List;

    final productDetails = items.map((item) {
      return {
        "name": item["product_name"] ?? item["name"] ?? "",
        "qty": item["qty"] ?? 0,
        "unitPrice": item["unit_price"] ?? item["price"] ?? 0,
      };
    }).toList();

    return _successLayout(
      context: context,
      receiptNumber: receipt,
      total: total,
      cashier: cashier,
      orderedAt: orderedAt,
      productDetails: productDetails,
      controller: controller,
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN SUCCESS LAYOUT FOR BOTH NORMAL + KHQR
  // ---------------------------------------------------------------------------
  Widget _successLayout({
    required BuildContext context,
    required String receiptNumber,
    required int total,
    required String cashier,
    required String orderedAt,
    required List<Map<String, dynamic>> productDetails,
    required SuccessController controller,
  }) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.paddingXL),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.marginXL * 2),

                // ✔ CHECK ICON
                Container(
                  padding: EdgeInsets.all(AppSpacing.paddingL),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(Icons.check,
                      size: AppWidgetSize.iconXL, color: Colors.white),
                ),

                SizedBox(height: AppSpacing.marginSmall),

                Text(
                  "Success",
                  style: TextStyle(
                    fontSize: AppFontSize.headlineSmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),

                SizedBox(height: AppSpacing.marginLarge),

                // ✔ INVOICE CARD
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
                  padding: EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.paddingM),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.list_alt_rounded,
                              size: AppWidgetSize.iconLarge,
                              color: AppColors.primary),
                          SizedBox(width: AppSpacing.marginSmall),
                          Expanded(
                            child: Text(
                              "$total ៛",
                              style: TextStyle(
                                fontSize: AppFontSize.titleLarge,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.marginMedium),

                      _infoRow("Cashier", cashier),
                      _infoRow("Receipt Number", "#$receiptNumber"),
                      _infoRow(
                        "Ordered At",
                        orderedAt.replaceAll("T", " ").replaceAll("Z", ""),
                      ),

                      SizedBox(height: AppSpacing.marginMedium),
                      Divider(),

                      // PRODUCT LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productDetails.length,
                        itemBuilder: (_, i) {
                          final p = productDetails[i];
                          final name = p["name"];
                          final qty = p["qty"];
                          final price = p["unitPrice"];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.paddingS),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: AppFontSize.titleSmall,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text("x$qty"),
                                SizedBox(width: 8),
                                Text("${qty * price} ៛",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.marginLarge),

                // ✔ ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton(Icons.print, () async {
                      await controller.downloadInvoicePdf(receiptNumber);
                    }),
                    SizedBox(width: AppSpacing.marginLarge),
                    _actionButton(Icons.download, () async {
                      await controller.downloadInvoicePdf(receiptNumber);
                    }),
                    SizedBox(width: AppSpacing.marginLarge),
                    _actionButton(Icons.share, () async {
                      controller.sharePdf(receiptNumber);
                    }),
                  ],
                ),

                SizedBox(height: AppSpacing.marginXL * 2),

                // ✔ REORDER BUTTON
                Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingM),
                  child: GestureDetector(
                    onTap: () => Get.offAllNamed("/home"),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          "Re-order",
                          style: TextStyle(
                            fontSize: AppFontSize.titleMedium,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------
  // INFO ROW WIDGET
  // --------------------------
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: AppFontSize.bodyMedium,
                  color: AppColors.lightTextPrimary)),
          Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: AppFontSize.bodyMedium,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // --------------------------
  // ACTION BUTTON
  // --------------------------
  Widget _actionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: AppWidgetSize.iconMedium),
      ),
    );
  }

  // --------------------------
  // SIMPLE SUCCESS (string)
  // --------------------------
  Widget _buildSimpleSuccess(BuildContext context, String receipt) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: AppColors.primary),
            SizedBox(height: AppSpacing.marginMedium),
            Text("ជោគជ័យ",
                style: TextStyle(
                  fontSize: AppFontSize.headlineSmall,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: AppSpacing.marginSmall),
            Text("Receipt #$receipt"),
            SizedBox(height: AppSpacing.marginLarge),
            ElevatedButton(
              onPressed: () => Get.offAllNamed("/home"),
              child: const Text("បញ្ជាទិញថ្មី"),
            )
          ],
        ),
      ),
    );
  }
}
