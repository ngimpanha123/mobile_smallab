import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font_size.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_widget_size.dart';
import '../../../data/models/cashier_order_model.dart';
import '../controllers/success_controller.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    // ⭐ Controller
    final controller = Get.find<SuccessController>();

    // ---- If simple string passed ----
    if (args is String) {
      return _buildSimpleSuccess(context, args);
    }

    // ---- If OrderData model passed ----
    final OrderData order = args as OrderData;

    final receiptNumber = order.receiptNumber ?? "";
    final total = order.totalPrice ?? 0;
    final cashier = order.cashier?.name ?? "Unknown";
    final orderedAt = order.orderedAt ?? "";
    final details = order.details ?? [];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.paddingXL),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.marginXL * 2),

                // TOP CHECK ICON
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

                // INVOICE CARD
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
                  padding: EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppSpacing.paddingM),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.marginMedium),

                      _infoRow("Cashier", cashier),
                      SizedBox(height: AppSpacing.marginSmall),
                      _infoRow("Receipt Number", "#$receiptNumber"),
                      SizedBox(height: AppSpacing.marginSmall),
                      _infoRow(
                          "Ordered At",
                          orderedAt.replaceAll("T", " ").replaceAll("Z", "")),

                      SizedBox(height: AppSpacing.marginMedium),
                      Divider(color: Colors.black12),

                      // PRODUCTS LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: details.length,
                        itemBuilder: (context, index) {
                          final detail = details[index];
                          final name = detail.product?.name ?? "";
                          final unitPrice = detail.unitPrice ?? 0;
                          final qty = detail.qty ?? 0;
                          final lineTotal = unitPrice * qty;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.paddingS,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style: TextStyle(
                                              fontSize:
                                              AppFontSize.titleSmall,
                                              fontWeight: FontWeight.w600)),
                                      Text("$unitPrice ៛",
                                          style: TextStyle(
                                              fontSize: AppFontSize.bodySmall,
                                              color: AppColors
                                                  .lightTextSecondary)),
                                    ],
                                  ),
                                ),
                                Text("x$qty",
                                    style: TextStyle(
                                      fontSize: AppFontSize.bodyMedium,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(width: AppSpacing.marginSmall),
                                Text("$lineTotal ៛",
                                    style: TextStyle(
                                        fontSize: AppFontSize.bodyMedium,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.marginLarge),

                /// ACTION ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton(Icons.print, () async {
                      await controller.downloadInvoicePdf(receiptNumber);
                      Get.snackbar("Print", "PDF saved. Open to print.");
                    }),

                    SizedBox(width: AppSpacing.marginLarge),

                    _actionButton(Icons.download, () async {
                      final path =
                      await controller.downloadInvoicePdf(receiptNumber);
                      if (path != null) {
                        Get.snackbar(
                            "Success", "Invoice saved to Downloads folder");
                      } else {
                        Get.snackbar("Error", "Download failed");
                      }
                    }),

                    SizedBox(width: AppSpacing.marginLarge),

                    _actionButton(Icons.share, () async {
                      await controller.sharePdf(receiptNumber);
                    }),
                  ],
                ),

                SizedBox(height: AppSpacing.marginXL * 2),

                // BACK TO HOME
                Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingM),
                  child: GestureDetector(
                    onTap: () => Get.offAllNamed("/home"),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.paddingM,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                        BorderRadius.circular(AppSpacing.paddingL * 1.2),
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

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
              fontSize: AppFontSize.bodyMedium,
              color: AppColors.lightTextPrimary,
            )),
        const Spacer(),
        Text(value,
            style: TextStyle(
              fontSize: AppFontSize.bodyMedium,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }

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
