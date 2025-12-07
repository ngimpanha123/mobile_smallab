// lib/app/modules/user/sale_detail/views/sale_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../controllers/sale_detail_controller.dart';

class SaleDetailView extends GetView<SaleDetailController> {
  const SaleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Sale Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // DOWNLOAD BUTTON
          Obx(() {
            return IconButton(
              icon: controller.isDownloading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.download),
              onPressed: controller.isDownloading.value
                  ? null
                  : () => controller.downloadInvoicePdf(),
            );
          }),

          // SHARE BUTTON
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => controller.shareInvoice(),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final sale = controller.sale.value;
        if (sale == null) {
          return const Center(child: Text("No sale detail found"));
        }

        final details = sale.details ?? [];

        return Column(
          children: [
            // -------------------------------------------------------------
            // TOP CARD
            // -------------------------------------------------------------
            Container(
              margin: EdgeInsets.all(AppSpacing.paddingM),
              padding: const EdgeInsets.all(20),
              decoration: AppColors.cardDecoration(),
              width: double.infinity,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RECEIPT NUMBER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#${sale.receiptNumber ?? '-'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginMedium),

                  // TOTAL PRICE
                  Text(
                    "${sale.totalPrice ?? 0} ៛",
                    style: TextStyle(
                      fontSize: AppFontSize.headlineMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),

                  SizedBox(height: AppSpacing.marginSmall),

                  // DATE + TIME
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(sale.orderedAt),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: AppFontSize.bodyMedium,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.marginSmall),

                  // PLATFORM BADGE
                  _buildPlatformBadge(sale.platform),

                  SizedBox(height: AppSpacing.marginSmall),

                  // CASHIER INFO
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          AppConfig.getImageUrl(sale.cashier?.avatar ?? ""),
                        ),
                      ),
                      SizedBox(width: AppSpacing.marginSmall),
                      Text(
                        sale.cashier?.name ?? "Unknown",
                        style: TextStyle(
                          fontSize: AppFontSize.titleSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // -------------------------------------------------------------
            // PRODUCT LIST
            // -------------------------------------------------------------
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
                itemCount: details.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.marginMedium),
                itemBuilder: (_, i) => _buildProductItem(details[i]),
              ),
            ),
          ],
        );
      }),
    );
  }

  // =====================================================================
  // PRODUCT ITEM CARD
  // =====================================================================
  Widget _buildProductItem(detail) {
    final qty = detail.qty ?? 0;
    final price = detail.unitPrice ?? 0;
    final subtotal = qty * price;

    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingM),
      decoration: AppColors.cardDecoration(),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              AppConfig.getImageUrl(detail.product?.image ?? ""),
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: AppSpacing.marginMedium),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.product?.name ?? "",
                  style: TextStyle(
                    fontSize: AppFontSize.titleSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "$qty × $price ៛",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // SUBTOTAL
          Text(
            "$subtotal ៛",
            style: TextStyle(
              fontSize: AppFontSize.titleMedium,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // PLATFORM BADGE
  // =====================================================================
  Widget _buildPlatformBadge(String? platform) {
    if (platform == null) return const SizedBox();

    Color color;
    IconData icon;

    switch (platform.toLowerCase()) {
      case "mobile":
        color = AppColors.success;
        icon = Icons.phone_android;
        break;
      case "web":
        color = AppColors.infoColor;
        icon = Icons.language;
        break;
      default:
        color = Colors.grey;
        icon = Icons.devices;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // TIME FORMATTER
  // =====================================================================
  String _formatTime(String? iso) {
    if (iso == null) return "--";

    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat("yyyy-MM-dd • hh:mm a").format(dt);
    } catch (_) {
      return iso;
    }
  }
}
